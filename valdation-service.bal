import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.validator;
import ballerina/io;

service /fhir\-validator on new http:Listener(9090) {
    resource function post validate(http:Caller caller, http:Request req) returns error? {
        json body;

        // Attempt to extract the JSON payload
        var result = req.getJsonPayload();
        if result is json {
            body = result;
        } else {
            io:println("Invalid JSON payload received.");
            http:Response response = new;
            response.statusCode = 400; // Bad Request
            response.setJsonPayload({ "successful": false, "errors": ["Invalid JSON format"] });
            check caller->respond(response);
            return;
        }

        // Validate the FHIR resource
        //r4:FHIRValidationError? validationResult = validator:validate(body);
        r4:FHIRValidationError? validationResult = validator:validate(body, international401:Observation);

        http:Response response = new;

        if validationResult is r4:FHIRValidationError {
            io:println("FHIR Validation Failed: ", validationResult.message());
            response.statusCode = 400; // Bad Request
            response.setJsonPayload({
                "successful": false,
                "errors": validationResult.message()
            });
            io:println(validationResult);
        } else {
            io:println("FHIR Validation Successful.");
            response.statusCode = 200; // OK
            response.setJsonPayload({ "successful": true, "errors": [] });
        }

        check caller->respond(response);
    }
}
