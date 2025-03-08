import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.validator;
import ballerina/io;

service /fhir\-validator on new http:Listener(9090) {
    resource function post validate(http:Caller caller, http:Request req) returns error? {
        json body = check req.getJsonPayload();

        r4:FHIRValidationError? validateFHIRResourceJson = validator:validate(body, international401:Patient);

        if validateFHIRResourceJson is r4:FHIRValidationError {
            http:Response response = new;
            response.setJsonPayload({
                "successful": false,
                "errors": validateFHIRResourceJson.message()
            });

            io:println(validateFHIRResourceJson);

            check caller->respond(response);
        } 
        
        check caller->respond({ "successful": true, "errors": [] });
    }
}