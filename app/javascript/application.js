// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import './add_jquery'


$(document).on('change', '#toggle-example', function (){
    debugger
    if(this.checked){
        $.ajax({
            url: "/two_factor_settings/new",
            method: 'get',
            data: {pincode: '234', invoice_id: '324'},
            success: function (response) {
                debugger
                $('#2f_auth').show();

            }, error: function (result) {

            }
        });
    }
})

$(document).on('click', '#close_btn', function (){
    $('#2f_auth').hide()
})



