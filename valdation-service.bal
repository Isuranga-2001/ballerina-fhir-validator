import ballerina/http;
import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.uscore700;
import ballerinax/health.fhir.r4.validator;
import ballerinax/health.fhir.r4.parser;

service /fhir\-validator on new http:Listener(9091) {
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
            response.setJsonPayload({"successful": false, "errors": ["Invalid JSON format"]});
            check caller->respond(response);
            return;
        }

        // Validate the FHIR resource
        r4:FHIRValidationError? validationResult = validator:validate(body);

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
            response.setJsonPayload({"successful": true, "errors": []});
        }

        check caller->respond(response);
    }

    resource function post validateUSCore700Patient(http:Caller caller, http:Request req) returns error? {
        json body;

        // Attempt to extract the JSON payload
        var result = req.getJsonPayload();
        if result is json {
            body = result;
        } else {
            io:println("Invalid JSON payload received.");
            http:Response response = new;
            response.statusCode = 400; // Bad Request
            response.setJsonPayload({"successful": false, "errors": ["Invalid JSON format"]});
            check caller->respond(response);
            return;
        }

        // Validate the FHIR resource with the given model
        r4:FHIRValidationError? validationResult = validator:validate(body, uscore700:USCorePatientProfile);

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
            response.setJsonPayload({"successful": true, "errors": []});
        }

        check caller->respond(response);
    }

    resource function post parser(http:Caller caller, http:Request req) returns error? {
        json body;

        // Attempt to extract the JSON payload
        var result = req.getJsonPayload();
        if result is json {
            body = result;
        } else {
            io:println("Invalid JSON payload received.");
            http:Response response = new;
            response.statusCode = 400; // Bad Request
            response.setJsonPayload({"successful": false, "errors": ["Invalid JSON format"]});
            check caller->respond(response);
            return;
        }

        // Parse the FHIR resource with validation
        var parseResult = parser:parseWithValidation(body);

        http:Response response = new;

        if parseResult is r4:FHIRValidationError {
            io:println("FHIR Parsing Failed: ", parseResult.message());
            response.statusCode = 400; // Bad Request
            response.setJsonPayload({
                "successful": false,
                "errors": parseResult.message()
            });
        } else {
            io:println("FHIR Parsing Successful.");
            response.statusCode = 200; // OK
            response.setJsonPayload({"successful": true, "parsedResource": parseResult.toJson()});
        }

        check caller->respond(response);
    }
}
