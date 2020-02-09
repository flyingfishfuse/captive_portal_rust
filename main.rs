/*
Total conversion of the project to Rust
I have officially decided to use my bash script as a pure linux solution
allowing me to create a safe sandbox environment to heighten the security
of the portal. It will be presented as an advanced option during setup.

make a script to do this automagically
/etc/NetworkManager/NetworkManager.conf
[main]
dns=dnsmasq
sudo systemctl restart NetworkManager
sudo rm /etc/resolv.conf; sudo ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf

CHANGE /etc/default/dnsmasq TO IGNORE SYSTEMD-RESOLVE SHIT


beef needs config files changed or saved here

so does metasploit

w3af:

remove python-webkit from the install line in the /tmp/w3af_install.sh
sudo apt-get install gir1.2-webkit-3.0 python-gi

and apparently you need ot install webkit manually from:



necessary for hacking module:
resolvconf
beef
metasploit
phishing frenzy
armitage

#########################################
##                                     ##
##        Rusty Things To Learn        ##
##                                     ##
######################################## #
#  - println!("{}{}", foo, bar);
#    - String concatention WHEN PRINTING TO TERMINAL
#
#
#    ERROR HANDLING STUFF:#

Results in Rust can be chained using and_then. So you can do this:

    let do_steps = || -> Result<(), MyError> {
        do_step_1()?;
        do_step_2()?;
        do_step_3()?;
        Ok(())
    };
    ==================================================
if let Err(e) = do_step_1().and_then(do_step_2).and_then(do_step_3) {
    println!("Failed to perform necessary steps");
}

PANIC IF RESULTS NOT ACCORDING TO PROPHESY!
if gift == "snake" { panic!("AAAaaaaa!!!!"); }


A value of type str is a Unicode string, represented as an array of 8-bit unsigned bytes
 holding a sequence of UTF-8 code points. Since str is a dynamically sized type, it is not 
 a first-class type, but can only be instantiated through a pointer type, such as &str.


# csrf-token = { git = "ssh://git@github.com/3dom-co-jp/csrf-token.git"}


*/

/*
  Load all external "modules"
*/
mod captive_portal_option_parser;
mod login_redirect_generator;
mod noodle_tail;
mod threadpoo;
mod USER_AUTH;
//mod oauth2;
// USE LIKE THIS captive_portal_option_parse::parse_commandline_arguments()

//extern crate scoped_threadpool;
//use scoped_threadpool::Pool;
extern crate clap;
// thread pool from documentation
//use threadpool::ThreadPool;


//Basic stuff
use std::char;
use std::thread;
use std::time::Duration;
use std::io::{self, Write};
use termcolor::{Color, 
                ColorChoice, 
                ColorSpec, 
                StandardStream, 
                WriteColor};
use clap::{Arg, App};

//Ncurses
extern crate ncurses;
use ncurses::*;


//Network stuff
use std::net::{SocketAddr,
              TcpListener, 
              TcpStream, 
              IpAddr, 
              Ipv4Addr, 
              Ipv6Addr};
use std::io::prelude::*;
use std::process::Command;
// Some variables for static things

let max_threads = 4;

// add conditional to use ncurses output
fn shutdown_server(){
    termcolorprint( "red", "SHUTTING DOWN");
    //add stuff here
}

// This is getting put in a seperate file
/// Find and store the info on EVERY device seen.
/// we gonna be impersonating them mebbe.
fn save_network_device_info(){

}

/////////////////////////////////////////////////
/* Setup http responder*/////////////////////////
// portal IP is an array 
//   SocketAddr::from(([127, 0, 0, 1], 80))
//   let portal_ip = [127, 0, 0, 1]
//   SocketAddr::from((portal_ip, 80))
/////////////////////////////////////////////////
fn setup_listener(portal_ip: [i32; 3], localhost_port: i32){
    // these are the addresses we want to create for the captive portal to use
    // localhost for some stuff
    let localhost_address = SocketAddr::from(([127, 0, 0, 1], localhost_port));
    let portal_address    = [
        // port 80 for standard HTTP connections
        SocketAddr::from((portal_ip, 80)),
        // port 443 for SSL!
        SocketAddr::from((portal_ip, 443)),
        ];
    // bind to all addresses
    let https_listener = TcpListener::bind(&addrs[..]).unwrap();
    // binds listener to interface at IP and PORT
    let localhost_listener = TcpListener::bind(&localhost_address).unwrap();
    // only so many threads can be allowed to prevent DDOS, race conditions, and possible buffer overflows
}    
// pass function like:
// threader(function_to_run)
//
// AND have "execute()" in the function being passed
fn generic_threader(num_threads : i32 , process_to_thread : fn() ) {
    if num_threads < max_threads {
        let mut pool = ThreadPool::new(num_threads);
        process_to_thread
    } else {

    }
}

fn connection_threader( num_threads : i32 ) {
    if num_threads < max_threads {
        let mut pool = ThreadPool::new(num_threads);
        for stream in listener.incoming() {
            let stream = stream.unwrap();
            // Spawn a new thread for every connection up to the maximum
            pool.execute(|| {
                handle_connection(stream);
            });
            //thread::spawn(|| {
            //    handle_connection(stream);
            //});
        }
    } else {

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
    // Assign the following two by getting terminal 
// dimensions
//let height_rows               = 0;
//let width_columns             = 0;
// set by finding minimum size necessary 
// for properly displaying the data presented
//let mut init_display_height   = 0;
//let mut init_display_width    = 0;

  /* Setup ncurses. */
  initscr();
  raw();
  /* Allow for extended keyboard (like F1). */
  keypad(stdscr(), true);
  noecho();
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
