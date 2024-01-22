import sys
import getopt
import yaml
import json

def main(argv):
    input_file = ''
    output_file = ''
    openapi = None
    privacy_notices_s3_bucket_arn = ''
    privacy_notices_role_arn = ''
    m2m_interface_specification_s3_bucket_arn = ''
    m2m_interface_specification_role_arn = ''

    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["input=", "output="])
    except getopt.GetoptError:
        print('openapi_integration.py -i <input-file> [-o <output-file>]')
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print('openapi_integration.py -i <input-file> [-o <output-file>]')
            sys.exit()
        elif opt in ("-i", "--input"):
            input_file = arg
        elif opt in ("-o", "--output"):
            output_file = arg

    if input_file == '':
        print('openapi_integration.py -i <inputfile> [-o <outputfile>]')
        sys.exit(2)

    #Get the JSON input from the Terraform query object
    input_json = sys.stdin.read()
    #Convert the JSON input into a dictionary
    input_data = json.loads(input_json)

    with open(input_file, mode="r", encoding="utf-8") as f:
        openapi = yaml.load(f, Loader=yaml.FullLoader)

    #Load the inputs into the appropriate variables
    privacy_notices_s3_bucket_arn = input_data.get("privacy_notices_s3_bucket_arn")
    privacy_notices_role_arn = input_data.get("privacy_notices_role_arn")
    m2m_interface_specification_s3_bucket_arn = input_data.get("m2m_interface_specification_s3_bucket_arn")
    m2m_interface_specification_role_arn = input_data.get("m2m_interface_specification_role_arn")

    #Edit the uri and credentials attributes into the BFF OpenAPI Additional Paths file with the input received from Terraform
    openapi['paths']['/consent/latest/{lang}/pp.json']['get']['x-amazon-apigateway-integration']['uri'] = privacy_notices_s3_bucket_arn + "/consent/latest/{lang}/pp.json"
    openapi['paths']['/consent/latest/{lang}/pp.json']['get']['x-amazon-apigateway-integration']['credentials'] = privacy_notices_role_arn
    openapi['paths']['/consent/latest/{lang}/tos.json']['get']['x-amazon-apigateway-integration']['uri'] = privacy_notices_s3_bucket_arn + "/consent/latest/{lang}/tos.json"
    openapi['paths']['/consent/latest/{lang}/tos.json']['get']['x-amazon-apigateway-integration']['credentials'] = privacy_notices_role_arn
    openapi['paths']['/m2m/interface-specification.yaml']['get']['x-amazon-apigateway-integration']['uri'] = m2m_interface_specification_s3_bucket_arn + "/m2m/interface-specification.yaml"
    openapi['paths']['/m2m/interface-specification.yaml']['get']['x-amazon-apigateway-integration']['credentials'] = m2m_interface_specification_role_arn
        
    if output_file != '':
        with open(output_file, mode="w", encoding="utf-8") as f:
            yaml.dump(openapi, f, sort_keys=False, encoding="utf-8")

    print(json.dumps({
        'computed_openapi_yaml': yaml.dump(openapi)
    }))

if __name__ == "__main__":
    main(sys.argv[1:])
