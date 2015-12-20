#= require active_admin/base
#= require active_admin/sortable
#= require active_admin/select2
#=require jquery-ui
#=require jquery-ui-timepicker-addon.min
#= require_tree .

# $(document).ready ->
#   ('input.hasDatetimePicker').datetimepicker
#     dateFormat: 'dd/mm/yy'
#     beforeShow: ->
#       setTimeout (->
#         $('#ui-datepicker-div').css 'z-index', '3000'
#         return
#       ), 100
#       return
#   return
#
#   $(document).on 'click', '.has_many_add', ->
#       console.log('dd')
#       ('input.hasDatetimePicker').datetimepicker
#         dateFormat: 'dd/mm/yy'
#         beforeShow: ->
#           setTimeout (->
#             $('#ui-datepicker-div').css 'z-index', '3000'
#             return
#           ), 100
#           return
#       return
