import sys
import getopt
import yaml
import json

def main(argv):
    input_file = ''
    output_file = ''
    api_name = ''
    integrated_openapi = None
    privacy_notices_s3_bucket_arn = ''
    frontend_additional_assets_s3_bucket_arn = ''
    frontend_additional_assets_role_arn = ''

    try:
        opts, args = getopt.getopt(argv, "hi:o:n:", ["input=", "output=", "api-name="])
    except getopt.GetoptError:
        print('openapi_integration.py -i <input-file> [-o <output-file>] [-n <api-name>]')
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print('openapi_integration.py -i <input-file> [-o <output-file>] [-n <api-name>]')
            sys.exit()
        elif opt in ("-i", "--input"):
            input_file = arg
        elif opt in ("-o", "--output"):
            output_file = arg
        elif opt in ("-n", "--api-name"):
            api_name = arg

    if input_file == '':
        print('openapi_integration.py -i <inputfile> [-o <outputfile>] [-n <api-name>]')
        sys.exit(2)

    with open(input_file, mode="r", encoding="utf-8") as f:
        integrated_openapi = yaml.load(f, Loader=yaml.FullLoader)

    #If we're creating the "frontend-assets" APIGW, then:
    if api_name == "frontend-assets":
        #Get the JSON input from the Terraform query object
        input_json = sys.stdin.read()
        #Convert the JSON input into a dictionary
        input_data = json.loads(input_json)

        #Load the inputs into the appropriate variables
        privacy_notices_s3_bucket_arn = input_data.get("privacy_notices_s3_bucket_arn")
        frontend_additional_assets_s3_bucket_arn = input_data.get("frontend_additional_assets_s3_bucket_arn")
        frontend_additional_assets_role_arn = input_data.get("frontend_additional_assets_role_arn")

        #Edit the uri and credentials placeholders into the method integration with the input received from Terraform when the method object contains the tag 's3'
        if 'paths' in integrated_openapi:
            paths = integrated_openapi['paths']
            for path, path_content in paths.items():
                for method, method_content in path_content.items():
                    if 'x-amazon-apigateway-integration' not in method_content:
                        raise ValueError(f"No API Gateway Integration defined for the {method.upper()} method in the {path} path.")
                    if ('tags' in method_content) and ('s3' in method_content['tags']):
                        integration_content = method_content['x-amazon-apigateway-integration']
                        integration_content['uri'] = integration_content['uri'].replace("$PrivacyNoticesS3BucketARN", privacy_notices_s3_bucket_arn + path)
                        integration_content['uri'] = integration_content['uri'].replace("$FrontendAdditionalAssetsS3BucketARN", frontend_additional_assets_s3_bucket_arn + path)
                        integration_content['credentials'] = integration_content['credentials'].replace("$FrontendAdditionalAssetsRoleARN", frontend_additional_assets_role_arn)                      

    if output_file != '':
        with open(output_file, mode="w", encoding="utf-8") as f:
            yaml.dump(integrated_openapi, f, sort_keys=False, encoding="utf-8")

    print(json.dumps({
        'integrated_openapi_yaml': yaml.dump(integrated_openapi)
    }))

if __name__ == "__main__":
    main(sys.argv[1:])
