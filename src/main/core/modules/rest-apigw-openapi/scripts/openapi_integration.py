import sys
import getopt
import copy
import yaml
import json

http_methods = ["get", "head", "options", "trace", "post", "put", "patch", "delete"]

def generate_apigw_integration(path_uri, path_parameters, api_version, use_service_prefix):
    base_integration_uri = "http://${stageVariables.NLBDomain}"

    if use_service_prefix:
        base_integration_uri += "/${stageVariables.ServicePrefix}"

    if api_version != '':
        base_integration_uri += "/${stageVariables.ApiVersion}"

    request_integration = {
        "type":  "http_proxy",
        "httpMethod": "ANY",
        "passthroughBehavior": "when_no_match",
        "connectionId": "${stageVariables.VpcLinkId}",
        "connectionType": "VPC_LINK",
        "uri": f"{base_integration_uri}{path_uri}"
    }

    if len(path_parameters) > 0:
        path_integrations = dict()
        for param in path_parameters:
            path_integrations[f"integration.request.path.{param}"] = f"method.request.path.{param}"
        request_integration["requestParameters"] = path_integrations

    return request_integration

def integrate_path(path_uri, path_data, api_version, use_service_prefix):
    path_params = []

    # TODO: OpenAPI spec allows refs for parameters, but we don't support it at the moment
    if "parameters" in path_data:
        parameters = path_data["parameters"]
        path_params = [param.get("name") for param in parameters if param.get("in") == "path"]

    # TODO: OpenAPI spec allows refs for parameters, but we don't support it at the moment
    for method in path_data:
        if method not in http_methods: continue # ignore fields such as 'description'

        if "parameters" in path_data[method]:
            parameters = path_data[method]["parameters"]
            path_params = list(set(path_params + [param.get("name") for param in parameters if param.get("in") == "path"]))

        path_data[method]["x-amazon-apigateway-integration"] = generate_apigw_integration(path_uri, path_params, api_version, use_service_prefix)

    return path_data

def integrate_openapi(openapi, api_version, use_service_prefix):
    integrated_openapi = copy.deepcopy(openapi)

    for path in integrated_openapi["paths"]:
        integrated_openapi["paths"][path] = integrate_path(path, integrated_openapi["paths"][path], api_version, use_service_prefix)

    integrated_openapi["x-amazon-apigateway-binary-media-types"] = ["multipart/form-data"]

    return integrated_openapi

def main(argv):
    input_file = ''
    output_file = ''
    api_version = ''
    use_service_prefix = False
    is_bff = False
    swagger_additional_path_file = ''
    openapi = None
    integrated_openapi = None

    try:
        opts, args = getopt.getopt(argv, "hi:o:v:pbs:", ["input=", "output=", "api-version=", "use-service-prefix", "backend-for-frontend", "swagger"])
    except getopt.GetoptError:
        print('openapi_integration.py -i <input-file> [-o <output-file>] [-v <api-version>] [-p] [-b] [-s <swagger-additional-path-file>]')
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print('openapi_integration.py -i <input-file> [-o <output-file>] [-v <api-version>] [-p] [-b]')
            sys.exit()
        elif opt in ("-i", "--input"):
            input_file = arg
        elif opt in ("-o", "--output"):
            output_file = arg
        elif opt in ("-v", "--api-version"):
            api_version = arg
        elif opt in ("-p", "--use-service-prefix"):
            use_service_prefix = True
        elif opt in ("-b", "--backend-for-frontend"):
            is_bff = True
        elif opt in ("-s", "--swagger"):
            swagger_additional_path_file = arg

    if input_file == '':
        print('openapi_integration.py -i <inputfile> [-o <outputfile>] [-v <api-version>] [-p] [-b]')
        sys.exit(2)

    '''
    #Get the JSON input from the Terraform query object
    input_json = sys.stdin.read()
    #Convert the JSON input into a dictionary
    input_data = json.loads(input_json)
    '''
    
    with open(input_file, mode="r", encoding="utf-8") as f:
        openapi = yaml.load(f, Loader=yaml.FullLoader)

    #Integrate the OpenAPI
    integrated_openapi = integrate_openapi(openapi, api_version, use_service_prefix)

    if swagger_additional_path_file != '':
        #Open the Swagger additional path file
        with open(swagger_additional_path_file, mode="r", encoding="utf-8") as f:
            #Load the content of the Swagger additional path file into the swagger_additional_paths_content variable
            swagger_additional_paths_file_content = yaml.load(f, Loader=yaml.FullLoader)
            #Copy the content of the paths object into the swagger_additional_paths variable
            swagger_additional_paths_file_paths = copy.deepcopy(swagger_additional_paths_file_content.get("paths", {}))
            #Append the content of the bff_openapi_additional_paths to the bottom of the paths object into the integrated_openapi variable
            integrated_openapi['paths'].update(swagger_additional_paths_file_paths)


    #If the APIGW is related to the BFF, then:
    if is_bff:
        #Add the prefix "/backend-for-frontend" to any path in the "paths object" of the BFF OpenAPI
        for path in list(integrated_openapi.get('paths', {}).keys()):
            edited_path = f'/backend-for-frontend{path}'
            integrated_openapi['paths'][edited_path] = integrated_openapi['paths'].pop(path)
        
        '''
        #Load the additional paths file
        additional_paths_file = input_data.get("additional_paths_file")

        #Open the BFF OpenAPI Additional Paths file
        with open(additional_paths_file, mode="r", encoding="utf-8") as f:
            #Load the content of the BFF OpenAPI Additional Paths file into the additional_paths_content variable
            additional_paths_content = yaml.load(f, Loader=yaml.FullLoader)

            #Edit the uri and credentials attributes into the BFF OpenAPI Additional Paths file with the input received from Terraform
            additional_paths_content['paths']['/consent/latest/{lang}/pp.json']['get']['x-amazon-apigateway-integration']['uri'] = privacy_notices_s3_bucket_arn + "/consent/latest/{lang}/pp.json"
            additional_paths_content['paths']['/consent/latest/{lang}/pp.json']['get']['x-amazon-apigateway-integration']['credentials'] = privacy_notices_role_arn
            additional_paths_content['paths']['/consent/latest/{lang}/tos.json']['get']['x-amazon-apigateway-integration']['uri'] = privacy_notices_s3_bucket_arn + "/consent/latest/{lang}/tos.json"
            additional_paths_content['paths']['/consent/latest/{lang}/tos.json']['get']['x-amazon-apigateway-integration']['credentials'] = privacy_notices_role_arn

            #Copy the content of the paths object into the bff_openapi_additional_paths variable
            bff_openapi_additional_paths = copy.deepcopy(additional_paths_content.get("paths", {}))

            #Append the content of the bff_openapi_additional_paths to the bottom of the paths object into the integrated_openapi variable
            integrated_openapi['paths'].update(bff_openapi_additional_paths)
        '''

    if output_file != '':
        with open(output_file, mode="w", encoding="utf-8") as f:
            yaml.dump(integrated_openapi, f, sort_keys=False, encoding="utf-8")

    print(json.dumps({
        'integrated_openapi_yaml': yaml.dump(integrated_openapi)
    }))

if __name__ == "__main__":
    main(sys.argv[1:])
