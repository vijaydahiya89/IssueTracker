function validate_form(summary_field_id)
{
    summary = document.getElementById(summary_field_id);
    var valid = true;
    if (summary.value.trim() == "")
    {
        alert("Summary cannot be empty!");
        valid = false;
    }
    return valid;
}
