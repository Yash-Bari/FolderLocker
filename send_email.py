import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import sys

# Email configuration
sender_email = "your_mail_id"
sender_password = "your_password"
recipient_email = sys.argv[1]  # Recipient's email address from command-line argument
foldername = sys.argv[2]  # Folder name from command-line argument
password = sys.argv[3]  # Password from command-line argument

# Create message
message = MIMEMultipart()
message["From"] = sender_email
message["To"] = recipient_email
message["Subject"] = "Folder Creation Details"

# Build the email body with folder name and password
body = f"Folder Name: {foldername}\nPassword: {password}"
message.attach(MIMEText(body, "plain"))

# Send email
with smtplib.SMTP("smtp.gmail.com", 587) as server:
    server.starttls()
    server.login(sender_email, sender_password)
    server.sendmail(sender_email, recipient_email, message.as_string())
