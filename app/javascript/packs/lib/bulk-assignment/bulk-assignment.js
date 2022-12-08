import $ from 'jquery'

$(function(){
  const container = $('#bulk-assign-container');
  if (container.length > 0) {
    InitBulkAssignment(container[0])
  }
});

function hasCheckedCheckboxes() {
  const checkedCheckboxes = $("input[type='checkbox'][name='assign[]']:checked");
  return checkedCheckboxes.length > 0;
} 

function InitBulkAssignment(element) {
  const selector = $(element).find('.volunteer-select')
  const checkboxes = $("input[type='checkbox'][name='assign[]']");
  
  const button = $(element).find("#bulk-assign-button");
  checkboxes.on('change', function() {
    return $(element).toggle(hasCheckedCheckboxes())
  });

  selector.on('change', function() {
    button.toggle(!!selector.val())
  })
  $(element).hide();
  button.hide();
};
