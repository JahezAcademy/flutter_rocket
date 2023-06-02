import openai
openai.api_key = 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik1UaEVOVUpHTkVNMVFURTRNMEZCTWpkQ05UZzVNRFUxUlRVd1FVSkRNRU13UmtGRVFrRXpSZyJ9.eyJodHRwczovL2FwaS5vcGVuYWkuY29tL3Byb2ZpbGUiOnsiZW1haWwiOiJtOTcuY2hhaGJvdW5AZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWV9LCJodHRwczovL2FwaS5vcGVuYWkuY29tL2F1dGgiOnsidXNlcl9pZCI6InVzZXItaEhGakFzWFpjZEFXWmNSSlZFWFBYcEoxIn0sImlzcyI6Imh0dHBzOi8vYXV0aDAub3BlbmFpLmNvbS8iLCJzdWIiOiJnb29nbGUtb2F1dGgyfDExMDA1NTA5MDAyNTkxMDc4MzgzOSIsImF1ZCI6WyJodHRwczovL2FwaS5vcGVuYWkuY29tL3YxIiwiaHR0cHM6Ly9vcGVuYWkub3BlbmFpLmF1dGgwYXBwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE2ODQ2NzkwMDAsImV4cCI6MTY4NTg4ODYwMCwiYXpwIjoiVGRKSWNiZTE2V29USHROOTVueXl3aDVFNHlPbzZJdEciLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIG1vZGVsLnJlYWQgbW9kZWwucmVxdWVzdCBvcmdhbml6YXRpb24ucmVhZCBvcmdhbml6YXRpb24ud3JpdGUifQ.tlSJ7jAqtuth4hSIoQvwahAXejK5oe-aQ4QerjbXYYI2OOoiXyoKOmVkc98We3ni4pZZqGpGIHKHIJFOFq4vONtqR0H7jTfyZ4O6oOdOKGaSargMFJlDayjQhO31XeqUChLN2EenrSmrv88dmuW8WWDzOC_8DscpL7NDh4iJDKgAsjPxGGO8Gw6ck-MCzM_EpkwNb_D9BF_LmavhmuhuKrwPaniic3hV5kN65VQVviNlD5QaQ3fDGTubw_s4s3c0mvEhj0I0w4-_Sw0nldUZHZXixJXmctQJJqfIz7QXnN_sAHS_r9CiqKn_W9cKgPUy1dzEOga78bUP_4Wh2EXDlw'
messages = [ {"role": "system", "content": 
              "You are a intelligent assistant."} ]
while True:
    message = input("User : ")
    if message:
        messages.append(
            {"role": "user", "content": message},
        )
        chat = openai.ChatCompletion.create(
            model="gpt-3.5-turbo", messages=messages
        )
    reply = chat.choices[0].message.content
    print(f"ChatGPT: {reply}")
    messages.append({"role": "assistant", "content": reply})