function validate_form(summary_field_id,error_message)
{
    summary = document.getElementById(summary_field_id);
    var valid = true;
    if (summary.value.trim() == "")
    {
        alert(error_message+" cannot be empty !");
        valid = false;
    }
    return valid;
}
