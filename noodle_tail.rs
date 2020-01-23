/*  Noodle Tails, Solving all your spaghetty code needs since I first thought of it!*/
// Here we got all the functions that don't fit elsewhere... carefully documented please!


// print to terminal with color funtion
// add an error logger HERE maybe?
fn termcolorprint(text_color, text ) -> io::Result<()> {
    let mut stdout = StandardStream::stdout(ColorChoice::Always);
    stdout.set_color(ColorSpec::new().set_fg(Some(Color::text_color)))?;
    writeln!(&mut stdout, text)
};

//why do I have to do this people?
// This is a series of various string concatention functions
fn concat_format(text1 , text2){
    format!("{}{}", text1 , text2)
}
fn concat_print(text1 , text2){
    println!("{}{}", text1 , text2)
}
