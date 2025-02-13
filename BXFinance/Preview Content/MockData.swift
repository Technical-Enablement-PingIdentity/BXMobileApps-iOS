//
//  Untitled.swift
//  BXMobileApps-iOS
//
//  Created by Eric Anderson on 12/12/24.
//

import SwiftyJSON

extension FinanceGlobalViewModel {
    
    static var preview = FinanceGlobalViewModel(accessToken: "eyJhbGciOiJSUzI1NiIsImtpZCI6ImNlcnQiLCJwaS5hdG0iOiJpN2dsIn0.eyJzY29wZSI6IiIsImNsaWVudF9pZCI6ImJ4RmluYW5jZU1vYmlsZSIsInN1YiI6ImV0ZXN0IiwicGkuc3JpIjoiSHhfTXhrbnlKNUk0OFlKVHNIZUVPX3RUS2lRLi5Xd1hLLnA5VmJHN0RvRXk1WElnWDBSZXljeFZvejUiLCJleHAiOjE3MzQwMjU3MDd9.UjR3FM2Y5lQjQ2Z46RCLWTWTEFwkqoAR7rjoyH5En9ycJbPhVtOIgAx41lamlxhOdrgu98POeFl2-FPPaE75xdFaejnsy5lpMBWifAwyxW-dBCtctSC8gADyJmluuPCNcc78nNOWtCOKgnuiJz8G9ym0CX0LEazWU_7wsSjdRdh9bg-GIwzhGK0IJHfGFuOis3Q6YRTMCObMvYPW-h-eKW4yzgy4xqD7aPV2Z7QLHEUOCZwk6dqRNbwIp_L7BpnuU9xWysUAyW4jMGh4P1K4JHql-v9FibQQKZLJUyydZyuNiErDpGEokqx2567A5gI0JFhIg9NxH_MRcXHIIZ2rtQ", idToken: "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhNaktZNk5ZbVItU3pFU0xENnQzZVZhNDE1RV9SUzI1NiJ9.eyJzdWIiOiJldGVzdCIsImF1ZCI6ImJ4RmluYW5jZU1vYmlsZSIsImp0aSI6IktjS25FclRqcjhoa2tIR3diQ2hNUmIiLCJpc3MiOiJodHRwczovL2J4ZmluYW5jZS1kZWMtZWEucGluZy1kZXZvcHMuY29tIiwiaWF0IjoxNzM0MDI3NDc4LCJleHAiOjE3MzQwMjc3NzgsImF1dGhfdGltZSI6MTczNDAyNzQ3OCwibGFzdF9uYW1lIjoiQW5kZXJzb24iLCJmaXJzdF9uYW1lIjoiRXJpYyIsImVtYWlsIjoiZXJpY2FuZGVyc29uK2V0ZXN0QHBpbmdpZGVudGl0eS5jb20iLCJwaS5zcmkiOiJTckotNnMzSVFwb21nWWk0Sm5pOF94aWlSaG8uLld5alYueEs3dWM1QlhXeUdIYmtlSFY3VkhsYjQycCIsInNpZCI6IlNySi02czNJUXBvbWdZaTRKbmk4X3hpaVJoby4uV3lqVi54Szd1YzVCWFd5R0hia2VIVjdWSGxiNDJwIiwibm9uY2UiOiJ4eXoxMjM0MzQyIiwiYXRfaGFzaCI6IjhpVVZ0QXg0dWkxQ083TWdjUDkwRmcifQ.MRABAaTx_GD3ZXrVul2TweOMywlnZEYXe67DhGwuPVaSXCkWNox297cdaa1nhIuS7OeIT_1HEAHezuWYnFKTOypFT8cJgU0nPDy4DW5TR1R9i1-79PhtBTKV-pJ4C1fJTa_6mvPmYHI5a0ZJdYae3FI4uC3uTZDXXtkvCU2zVlhoJpTJBqeOdmlA2QNllVvX9_f1mxowkyZbCqBX3SnMCP5mtwruyBo0fuMNlthiRGj2awG3w7sZcXDtbOUXr97wMwttUAdN4FLUS3nVgS6okDjXJ-IvUlOTRslBdP36lw93z7EgxIiEb1m9zj-Ek98kCr6n_eGGfFDeJ_MPu-gfmg")

}

struct MockDevices {
    var devices: [SelectableDevice]
    
    init() {
        devices = []
        
        do {
            let jsonRaw = "{\"devices\": [\r\n        {\r\n            \"id\": \"55338406-b17c-4528-a275-78808ab0508c\",\r\n            \"type\": \"Email\",\r\n            \"target\": \"er****@pingidentity.com\",\r\n            \"usable\": true,\r\n            \"defaultDevice\": false\r\n        },\r\n        {\r\n            \"id\": \"e7a399e4-0c30-45f2-93fa-3eb82a3bd6d3\",\r\n            \"type\": \"SMS\",\r\n            \"target\": \"*******13\",\r\n            \"usable\": true,\r\n            \"nickname\": \"SMS Number 1\",\r\n            \"defaultDevice\": false\r\n        },\r\n        {\r\n            \"id\": \"879ff907-7f04-47bc-9d22-d4b1ec64ce62\",\r\n            \"type\": \"iPhone\",\r\n            \"name\": \"iPhone Xs\",\r\n            \"applicationId\": \"028887be-5d57-4cb8-aeb9-874c4f202ae0\",\r\n            \"applicationVersion\": \"4.0(40)\",\r\n            \"osVersion\": \"18.2\",\r\n            \"usable\": true,\r\n            \"pushEnabled\": true,\r\n            \"otpEnabled\": true,\r\n            \"defaultDevice\": false\r\n        },\r\n        {\r\n            \"id\": \"695500f7-2f6e-4b9b-9107-70907366abb0\",\r\n            \"type\": \"TOTP\",\r\n            \"usable\": true,\r\n            \"defaultDevice\": false\r\n        }\r\n    ]}"
            let json = try JSON(data: jsonRaw.data(using: .utf8)!)

            let jsonDevices = json["devices"].array ?? []
            for device in jsonDevices {
                self.devices.append(try SelectableDevice(device: device))
            }
        } catch {
            devices = []
        }
    }
}
