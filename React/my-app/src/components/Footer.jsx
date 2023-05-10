import React from "react";

let currYear = new Date().getFullYear();

function Footer(){
    return (
        <footer>
            <p>Copyright: {currYear} </p>
        </footer>
    )
}
export default Footer;