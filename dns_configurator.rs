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

let resolv_conf = ""
let dnsmasq_conf = ""
let hosts_conf = ""
let hosts = ""
let hosts_allow = ""
let hosts_deny = ""
let hosts_conf = ""
let resolved_conf = ""
let resolved_conf_head = ""

