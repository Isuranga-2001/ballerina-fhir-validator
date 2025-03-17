# Ballerina FHIR Validator Service

This project is an example validator service to test the Ballerina Health FHIR Validator. It provides a RESTful API to validate FHIR resources using the Ballerina Health FHIR R4 Validator.

## Features

- Validate FHIR resources against the FHIR R4 specification.
- Validate FHIR resources against the US Core 700 Patient Profile.
- Return detailed validation errors if the resource is invalid.
- Return a success message if the resource is valid.

## Prerequisites

- Ballerina Swan Lake
- Ballerina Health FHIR R4 Validator package

## Getting Started

1. Clone the repository:

   ```sh
   git clone https://github.com/your-username/ballerina-fhir-validator.git
   cd ballerina-fhir-validator
   ```

2. Install the Ballerina Health FHIR R4 Validator package:

   ```sh
   bal pull ballerinax/health.fhir.r4.validator:4.3.0
   ```

3. Run the service:

   ```sh
   bal run validation-service.bal
   ```

## Usage

### Validate FHIR Resource

Send a POST request to the `/fhir-validator/validate` endpoint with the FHIR resource in the request body.

Example:

```sh
curl -X POST http://localhost:9090/fhir-validator/validate \
    -H "Content-Type: application/json" \
    -d '{
        "resourceType": "Patient",
        "id": "example",
        "name": [{
            "use": "official",
            "family": "Doe",
            "given": ["John"]
        }]
    }'
```

### Validate US Core 700 Patient Profile

Send a POST request to the `/fhir-validator/validateUSCore700Patient` endpoint with the FHIR resource in the request body.

Example:

```sh
curl -X POST http://localhost:9090/fhir-validator/validateUSCore700Patient \
    -H "Content-Type: application/json" \
    -d '{
        "resourceType": "Patient",
        "id": "example",
        "name": [{
            "use": "official",
            "family": "Doe",
            "given": ["John"]
        }]
    }'
```

## Response

- **200 OK**: If the FHIR resource is valid.

  ```json
  {
    "successful": true,
    "errors": []
  }
  ```

- **400 Bad Request**: If the FHIR resource is invalid.

  ```json
  {
    "successful": false,
    "errors": ["Error message"]
  }
  ```

## License

This project is licensed under the MIT License.
