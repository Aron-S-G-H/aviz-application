from django.core.mail import send_mail
from django.conf import settings
from celery import shared_task


@shared_task
def send_verification_code(code: str, user_email: str):
    try:
        send_mail(
            subject='فروشگاه پرایم سیستم',
            message=f'کد ورود شما به پرایم سیستم : {code} لطفا بعد از ورود کلمه عبور خود را ویرایش کنید ',
            from_email=settings.EMAIL_HOST_USER,
            recipient_list=[user_email],
            fail_silently=False,
        )
        return {"status": True, "message": "Email Verification Code Sent Successfully"}
    except Exception as ex:
        settings.LOGGER.error(f"Email Verification Code ERROR: {ex}")
        return {"status": False, "message": "An unexpected error occurred"}