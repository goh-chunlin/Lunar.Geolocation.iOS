# Lunar.Geolocation.iOS

## Important Notes
Firstly, create apikey.plist in the root folder (same level as geolocation.xcodeproj) and add API key. For more information of how to create the API key, follow the directions here: https://developers.google.com/maps/documentation/android/start#get-key

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
    <dict>
    
        <key>GoogleMapsiOSAPIKey</key>
        <string>AIza****************************</string>
        
    </dict>
</plist>

```

Secondly, we need to add the URL pointing to the Azure Event Hub as follows.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
    <dict>
        ...
        
        <key>AzureEventHubEndpoint</key>
        <string>https://<event-hub-namespace>.servicebus.windows.net/<event-hub-name></string>
        
    </dict>
</plist>

```

Thirdly, we need to setup an Azure Function app running the following .NET Core 3.1 codes to generate SAS Token (Microsoft Documentation here: https://docs.microsoft.com/en-us/rest/api/eventhub/generate-sas-token#c).
```
using System;
using System.Net;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using Microsoft.AspNetCore.Mvc;

public static async Task<IActionResult> Run(HttpRequest req, ILogger log)
{
    string sasToken = createToken("<event-hub-namespace>.servicebus.windows.net", "<event-hub-shared-access-policy-key-name>", "<event-hub-shared-access-policy-primary-key>");

    return (ActionResult)new OkObjectResult(sasToken);
}

private static string createToken(string resourceUri, string keyName, string key)
{
    TimeSpan sinceEpoch = DateTime.UtcNow - new DateTime(1970, 1, 1);
    var week = 60 * 60 * 24 * 7;
    var expiry = Convert.ToString((int)sinceEpoch.TotalSeconds + week);
    
    string stringToSign = HttpUtility.UrlEncode(resourceUri) + "\n" + expiry;
    HMACSHA256 hmac = new HMACSHA256(Encoding.UTF8.GetBytes(key));
    var signature = Convert.ToBase64String(hmac.ComputeHash(Encoding.UTF8.GetBytes(stringToSign)));

    var sasToken = String.Format(CultureInfo.InvariantCulture, "SharedAccessSignature sr={0}&sig={1}&se={2}&skn={3}", HttpUtility.UrlEncode(resourceUri), HttpUtility.UrlEncode(signature), expiry, keyName);
    
    return sasToken;
}
```

Fourthly, we need to add the URL pointing to the Azure Function above as follows.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
    <dict>
        ...
        
        <key>SasTokenGeneratorUrl</key>
        <string><azure-function-url></string>
        
    </dict>
</plist>

```

For securing safety API keys add apikey.plist to .gitignore.
