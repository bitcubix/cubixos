use clap::{arg, App, ArgMatches, crate_version};
use term_table::{Table, TableStyle, row::Row,
    table_cell::{Alignment, TableCell},
};

use super::{device, Disk};

pub fn create() -> App<'static> {
    App::new("disk")
        .version(crate_version!())
        .about("disk utils")
        .arg(arg!(-l --list "list disks"))
}

pub fn handle(matches: &ArgMatches) {
    if matches.is_present("list") {
        println!("\n{}", disk_list_table(device::get_disk_list()));
    }
}

fn disk_list_table(list: Vec<Disk>) -> String {
    let mut table = Table::new();
    table.style = TableStyle::simple();

    table.add_row(Row::new(vec![
        TableCell::new_with_alignment(
            "Path",
            1,
            Alignment::Center,
        ),
        TableCell::new_with_alignment(
            "Type",
            1,
            Alignment::Center,
        ),
        TableCell::new_with_alignment(
            "Capacity",
            1,
            Alignment::Center,
        ),
        TableCell::new_with_alignment(
            "Name",
            1,
            Alignment::Center,
        ),
    ]));

    for disk in list {
        table.add_row(Row::new(vec![
            TableCell::new(disk.path.to_str().unwrap()),
            TableCell::new(disk.media_type.to_string()),
            TableCell::new(disk.capacity.to_string()),
            TableCell::new(disk.name.unwrap_or(String::new())),
        ]));
    }

    table.render()
}
