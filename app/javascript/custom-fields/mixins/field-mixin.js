export default {
  methods: {
    getFieldName(index, key) {
      return `help_request[custom_values_attributes][${index}][${key}]`
    },

    getFieldId(index) {
      return `help_request_custom_values_attributes_${index}_value`
    },

   escapeHtml(unsafe) {
      return (unsafe || '')
           .replace(/&/g, "&amp;")
           .replace(/</g, "&lt;")
           .replace(/>/g, "&gt;")
           .replace(/"/g, "&quot;")
           .replace(/'/g, "&#039;");
    }
  }
}