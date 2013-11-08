# Used with Zurb Foundation. 
# ActionView::Base.field_error_proc = proc do |html_tag, instance|
#   is_label = html_tag[/^<label /] && true
#   if is_label
#     %(<div class="form-field error">#{html_tag}</div>)
#   else
#     %(<div class="form-field error">#{html_tag}<small class="error">#{[*instance.error_message].join(', ')}</small></div>)
#   end.html_safe
# end