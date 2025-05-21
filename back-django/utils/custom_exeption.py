from rest_framework.views import exception_handler
from rest_framework.exceptions import ValidationError

def custom_exception_handler(exc, context):
    # پاسخ پیش‌فرض DRF رو دریافت می‌کنیم
    response = exception_handler(exc, context)

    if response is not None:
        error_response = {
            'success': False,
            'error': {
                'status': response.status_code,
                'code': exc.__class__.__name__,
            }
        }

        if 'detail' in response.data:
            detail = response.data['detail']
            if isinstance(detail, list) and len(detail) > 0:
                error_message = str(detail[0])  # گرفتن متن از ErrorDetail
            else:
                error_message = str(detail)
        else:
            error_message = ""
            try:
                # اگر response.data یه دیکشنری فیلد‌محوره (مثل {'email': [...]})
                for field, errors in response.data.items():
                    if isinstance(errors, list) and len(errors) > 0:
                        # اولین خطای هر فیلد رو می‌گیره
                        error_message += f"{field}: {str(errors[0])} "
                    else:
                        error_message += f"{field}: {str(errors)} "
                error_message = error_message.strip()  # حذف فاصله اضافی
            except:
                error_message = str(exc) if str(exc) else response.data.get('detail','An error occurred')
        error_response['error']['message'] = error_message
        response.data = error_response
    return response

