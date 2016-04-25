// require('expose?$!expose?jQuery!jquery');

//^^^We’re actually running the
//expose loader twice here, to add jQuery to both window.$ and window.jQuery.
//The expose loader works like this: require(expose?<libraryName>!<moduleName>),
//where <libraryName> will be window.libraryName and <moduleName> 
//is the module you’re including, in this case jquery.
// You can chain loaders by separating them with !

var App = require('./app');
var _ = require('lodash');
var React = require('react');
var ReactDOM = require('react-dom')

var WST = require('./work_shift_table.js.jsx');
var CONST = require('./constants')

$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

if(document.getElementById(CONST.WORKSHIFT_TABLE_ID))
{
    var shifts = $('.temp_information').data('temp');
    var admin = $('.temp_information').data('is-admin');
    var allusers= $('.temp_information').data('allusers');
    ReactDOM.render(<WST shifts={shifts} table_type={CONST.W_SHIFT_TABLE}
                         admin={admin} allusers={allusers}/>, document.getElementById(CONST.WORKSHIFT_TABLE_ID));
} 

if(document.getElementById(CONST.SHIFT_TABLE_ID))
{
    var shifts = $('.temp_information').data('temp');
    var admin = $('.temp_information').data('is-admin');
    var allusers= $('.temp_information').data('allusers');
    ReactDOM.render(<WST shifts={shifts} table_type={CONST.SHIFT_TABLE}
                         admin={admin} allusers={allusers}/>, document.getElementById(CONST.SHIFT_TABLE_ID));
} 

var app = new App();
app.start();




