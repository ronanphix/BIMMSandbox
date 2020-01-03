/**
 * Created by ronanwilliams on 2019-10-18.
 */

public class DotMailerSync {


    // get all existing address books
    //"/v2/address-books"
    // link to generate doc
    // https://salesforcekings.blogspot.com/2016/10/how-to-create-or-generate-csv-file-in.html

    public static void getData(){


        Map<String,Map<String,String>> recordMap = new  Map<String,Map<String,String>>();

        List<Lead> enquiries = [SELECT Id, Email FROM Lead WHERE CreatedDate > :Date.today().addMonths(-5)];

        for (Lead enquiry : enquiries){
            if(!recordMap.containsKey(enquiry.Email)){
                recordMap.put(enquiry.Email,getFieldMap());
            }
        }

    }


    private static void generateCSVDoc(){

        String csvColumnHeader = ''; //

        for (String key : getFieldMap().keySet()){
            csvColumnHeader += key + ',';
        }

        csvColumnHeader += '\n';

        // String.valueOf(getFieldMap().keySet());
        List<String> csvRowValues = new List<String>();

        String documentName = 'SetupAuditTrailLog-'+ Datetime.now().format('MMM') + Datetime.now().year();
        csvColumnHeader = 'Date, User, Action, Section, Delegate User\n';
        String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');

        // Insert the generated CSV file in Document object under "Setup Audit Trail Logs".
        Document doc = new Document(
                Name = documentName,
                Body = Blob.valueOf(csvFile),
                Type = 'csv',
                ContentType='application/vnd.ms-excel');

        system.debug(doc);

    }


    public static Map<String,String> getFieldMap(){

        return new Map<String,String>{
                'Email' => null,
                'App_Status' => null,
                'Appoint_Outcome' => null,
                'Appoint_Start_Date' => null,
                'Appoint_Start_Day' => null,
                'Appoint_Start_Time' => null,
                'Appointment_Location' => null,
                'Appointment_Type' => null,
                'Assess_Date' => null,
                'Assess_Location' => null,
                'Assess_Outcome' => null,
                'Assess_Type' => null,
                'Campus' => null,
                'Course' => null,
                'Course_Area_2' => null,
                'Course_Level_2' => null,
                'Date_Of_Birth_2' => null,
                'Datedecisioncomplete' => null,
                'Decision' => null,
                'Enquiry_Date' => null,
                'Enquiry_Status' => null,
                'Firstname' => null,
                'Gender' => null,
                'Lastname' => null,
                'Main_Address' => null,
                'Main_Postcode' => null,
                'Marketing' => null,
                'Nationality' => null,
                'Phone' => null,
                'Postcode' => null,
                'Pref_Course_Area' => null,
                'Pref_Course_Level' => null,
                'Pref_Course_Location' => null,
                'Pref_Entry_Date' => null,
                'Reply_Status' => null,
                'Salutation' => null,
                'Sf_Accountid' => null,
                'Sf_Leadid' => null,
                'Source' => null,
                'Unite_Student_Ref' => null,
                'Year_Of_Entry' => null
        };

    }


    public static void postRandomContact(){


        Http http = new Http();
        HttpRequest request = new HttpRequest();
//        request.setEndpoint('https://r1-api.dotmailer.com/v2/address-books/739166/contacts');
        request.setEndpoint('https://r1-api.dotmailer.com/v2/address-books/853530/contacts');
        request.setMethod('POST');
//
//        String credentials = 'apiuser-0454fcda797c@apiconnector.com:4984gfFk';
        String credentials = 'apiuser-8d9f284f212e@apiconnector.com:4984gfFk';

        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(credentials)) );

        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"email":"dddjohn.smith@emailsim.io"}');
//request.setBody('"{ ""email"": ""john.smith@emailsim.io"", ""optInType"": ""Single"", ""emailType"": ""Html"", ""dataFields"": [ { key: ""FIRSTNAME"", value: ""John"" }, { key: ""FULLNAME"", value: ""John Smith"" }, { key: ""GENDER"", value: ""Male"" }, { key: ""LASTNAME"", value: ""Smith"" }, { key: ""POSTCODE"", value: ""N5 1DP"" } ] }"');

        HttpResponse response = http.send(request);
// If the request is successful, parse the JSON response.

        system.debug(response.getStatusCode() + ' ' + response.getBody());

        if (response.getStatusCode() == 200) {

        }

    }


    public static void postRandomContactBulk(){

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://r1-api.dotmailer.com/v2/address-books/853530/contacts/import');
        request.setMethod('POST');
        String credentials = 'apiuser-8d9f284f212e@apiconnector.com:4984gfFk';
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.Base64Encode(Blob.valueOf(credentials)) );
        request.setHeader('Content-Type', 'multipart/form-data; boundary=xxx');
//        request.setHeader('Content-Type', 'multipart/form-data;');
//        request.setHeader('Content-Type', 'application/xml;');
        request.setHeader('Content-Length', '1');
        String body = '-----------------------------153501500631101;\r\n';
        body += 'Content-Disposition = attachment; Name="fileData"; FileName="FileName.csv";\r\n';
        body += 'Content-Type = "text/csv";\r\n';
//        body += 'Email \r\n';
        body += 'xxx\r\n';

//        String body = '-----------------------------153501500631101;\n';
//        body += 'Content-Type: "text/csv";Content-Disposition: form-data; name="Filedata"; filename="Test.csv";\n';
//        body += 'Content-Type: "text/csv";\n';
//        body += 'Email \r\n';
//        body += '-----------------------------153501500631102--\n';

        request.setBody(body.escapeEcmaScript().replaceAll('\\\r\\\n|\\\r|\\\n', '<br />'));

        system.debug(body.escapeEcmaScript().replaceAll('\\\r\\\n|\\\r|\\\n', '<br />'));
//        request.setBodyAsBlob(Blob.valueOf(body));
        //request.setBody('"{ ""email"": ""john.smith@emailsim.io"", ""optInType"": ""Single"", ""emailType"": ""Html"", ""dataFields"": [ { key: ""FIRSTNAME"", value: ""John"" }, { key: ""FULLNAME"", value: ""John Smith"" }, { key: ""GENDER"", value: ""Male"" }, { key: ""LASTNAME"", value: ""Smith"" }, { key: ""POSTCODE"", value: ""N5 1DP"" } ] }"');

        HttpResponse response = http.send(request);
        System.debug(response.getStatusCode() + ' ' + response.getBody());



    }

    public static void BankAccountCSVFile_HTTPCallout(){

        String file_name = 'mav3rik12.csv';
//        Set<Id> setBillingAccountIds = new set<Id>();
//        setBillingAccountIds.add('RecordId');
        String file_body = 'dhjkjdhjkhkldfjshkljhdfskjh';

        String boundary = '----------------------------741e90d31eff';

        String header = '--'+boundary+'\nContent-Disposition: form-data; name="sourceFile"; filename="FileName";\nContent-Type: text/csv';
        String footer = '--'+boundary+'--';
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));

        while(headerEncoded.endsWith('=')) {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String bodyEncoded = EncodingUtil.base64Encode(blob.valueOf(file_body));

        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());

        if(last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else if(last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else {
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        }

//        HttpRequest req = new HttpRequest();
//        req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
//        req.setMethod('POST');
//        req.setEndpoint(sENDPOINT);
//        req.setHeader('authKey', 'XXXXXXXXXXXXXX');
//        req.setBodyAsBlob(bodyBlob);
//        req.setTimeout(120000);
//
//        Http http = new Http();
//        HTTPResponse res = http.send(req);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://r1-api.dotmailer.com/v2/address-books/739166/contacts/import');
        request.setMethod('POST');
        String credentials = 'apiuser-0454fcda797c@apiconnector.com:4984gfFk';
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(credentials)) );
        request.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
        request.setHeader('Content-Length',String.valueOf(bodyBlob));
        request.setBodyAsBlob(bodyBlob);
        HttpResponse response = http.send(request);
        System.debug(response.getStatusCode() + ' ' + response.getBody());
    }


    public static void attempt3(){


// change the following variables according to your use-case
        String fileName = 'MY_FILE.txt';
        String fileContent = 'Hello World';
        String separationString = 'A_RANDOM_STRING';

// assemble the body payload
        String header = '--' + separationString + '\nContent-Disposition: form-data; name="file"; filename="' + fileName + '"\nContent-Type: application/octet-stream\n\n';
        String body = EncodingUtil.base64Encode(Blob.valueOf(fileContent)) + '\n';
//        String body = fileContent + '\n';
        String footer = '--' + separationString + '--';
        String bodyPayload = header + body + footer;

// send out the request
        HttpRequest req = new HttpRequest();
        String credentials = 'apiuser-0454fcda797c@apiconnector.com:4984gfFk';
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(credentials)) );
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + separationString);
        req.setHeader('Content-Length', String.valueOf(bodyPayload.length()));
        req.setMethod('POST');
        req.setEndpoint('https://r1-api.dotmailer.com/v2/address-books/739166/contacts/import');
        req.setBody(bodyPayload);

        Http http = new Http();
        HttpResponse response = http.send(req);

        System.debug(response.getStatusCode() + ' ' + response.getBody());




    }

}