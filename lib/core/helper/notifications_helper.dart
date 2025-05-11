import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationsService {
  // ! get access token
  static Future<String> getAccessToken() async {
    final Map<String, String> serviceAccountJson = {
      // أدخل بيانات حساب الخدمة من ملف JSON هنا
      "type": "service_account",
      "project_id": "appnote-1a67a",
      "private_key_id": "8b74066a2e7ce110d61cdc5b720d1eaec8bc713e",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCf75AzHxw55Ypr\nUmeB26Mhun4shhqJpVQm506NDBfd5OIyw6vRhwMZMi063IDiHeYefercrapYzWHB\n6LXZM46Jv9D4dqUZ141ncKz8r+QUBZnQHgdALGwAYtQw/nMweuFrwCLxuab7rIJS\ndkNvm2uwvFIHyi/4bsmehg9v8YopAQgn6HrE5iAwhiT6BYx3XjUJJ257HGasnRWq\n/5pkF4jn6/SBm1VtYo251eGRv28gsN/vWyG9C6EioP5GjcSIWn96m4slrxMTP+7k\nxlqXHlRrsrHtbizWwSEDtObs5qibu7iwrEPUnSyI8z4XAOnEOMvI1Hu3M5Aako+Z\nllTbH8G5AgMBAAECggEAL597biV816aIZXWXmZzHggMQj/xsiYD/wkfM5YXs02dU\njW4jStQrcYS14BmJjQr/GyQ+W3Cg0SlyyvUatO67qjvCI0Hc3omHMv5jnChZvzZ9\nuvE+EndHv4OuEFqr/QsR9W40WYsA9F7FPX22jdSXJ/yjZmtnhk+i3H+puBkRnSyX\nSDIAfHDRFyEe3Er0q2p0KZD8sQYQLzq3mL7DDjZlW7UPQ6dWzFfYoKUlrktydbUt\nREKQvQT5OhLwGQLQYo25SR956W6bq71ZPDasQDKhkThgBDuCX0ESZUqhTJfSYZXB\n6+X2ADv8SivZ8ljwfyH+v92b9SA3XVfPPp9PTz/LGwKBgQC/GHMMpxVEU6Quaz2f\ndAFK+hE78LGRJMulHZUKQbCLOu1bhNJ/CCFMWcQXdMwKXEm+x3zpDoQajc2zbnW7\nXDmoKlVTWyKGeFsB0OzsT31jGGXaVsJloE+pIDEqPGeD/cfqSGSmggax6oYttm47\nfcTE6Qdlt/Ud3u7dvpbg6sToGwKBgQDWQc9mkUspaBzRtYq1hhYxE01lf8m8nw8K\nJMq6/iFj2qDNEkp2Jk3bJK9qoZb4hlt7DP2UwlDYQ0QLDmsmLdNg9FEr39IA5vEP\nnG0+TqzCSNohnVQKZTYUQYIJe1803Yx96RW0645A3o9uycIZdWQiqTKKLx++G/t5\nyBLjhg4CuwKBgCL7OcxeJbF9UjfBH+W5mab9AfykAg1c2/6c3LSk88l4/wxa0yG3\n/kh4wkG8+sEGxeUrpX0QUDSAMuCe3uRubIuRPE9nBnnxPE+nzEcyAfUK+VIvwaRS\n5WJDZ1yg9B4gbeFAYVRtxwX4tZlWpPU0/7lAIz+GnlNahQWIpxwDPgpzAoGBAKmv\nHxGNGiil4sUW8M7IbcTaE57B8MRoeCHBd6lWYJ1TZaxjwwMFXP2kdSSO6yDST5sJ\nc78fkaVkyHu1JJjtDA4qECseLJQ4UkvZyA7jgiCwT8j1b7x34bdzFghqY8FbgMur\nEFzjfRrU6GWGdilxdieZNoSHw6ztPmF5WbRF08zHAoGAM5xAHUyYfVdNnjSMoqAe\nYokHSImugINmx/E88h0duZcerH7qzmtBlDoZP1fbhvD3fqcXxef1Y7t1la6idM5q\nPS1mBys+onlNwp8cwHoWyIv4ZtnjsByfFdpTBI+/3cfPmGmH8x1+rmU3dhDiDcAL\nX+nstF43d14ZhbLmr/G74Ao=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-p32no@appnote-1a67a.iam.gserviceaccount.com",
      "client_id": "108499510992299789328",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-p32no%40appnote-1a67a.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  // ! send topic notification
  static Future<void> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
  }) async {
    final String accessToken = await getAccessToken();
    const String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/appnote-1a67a/messages:send'; 

    final Map<String, dynamic> message = {
      "message": {
        "topic": topic,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('✅ Notification sent to topic "$topic"');
    } else {
      print('❌ Failed to send notification: ${response.body}');
    }
  }
}
