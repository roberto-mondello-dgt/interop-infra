COPY interop_dev.jwt.generated
FROM 's3://interop-generated-jwt-details-dev-es1/token-details/'
IAM_ROLE 'arn:aws:iam::505630707203:role/interop-analytics-generated-jwt-loader-dev-es1'
FORMAT AS JSON 's3://interop-analytics-jsonpaths-dev-es1/jsonpaths.json';