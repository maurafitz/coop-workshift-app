
'use strict'

var React = require('react');
var Griddle = require('griddle-react');
var ReactDOM = require('react-dom');

var Button = require('react-bootstrap/lib/Button');
var Popover = require('react-bootstrap/lib/Popover');
var OverlayTrigger = require('react-bootstrap/lib/OverlayTrigger');

var moment = require('moment');

var DescriptionComponent;

String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
};

DescriptionComponent = React.createClass({
  displayName: 'DescriptionComponent',
  componentDidMount: function() {
    
  },

  render: function(){
    return (
      <div>
        <OverlayTrigger trigger="click" placement="left" overlay={<Popover title={this.props.rowData.shift}>{this.props.rowData.description}</Popover>}>
          <Button color="blue" type="button">Description</Button>
        </OverlayTrigger>
      </div>
    );}
});

var UserComponent = React.createClass({
  displayName: 'UserComponent',
  getInitialState: function(){
    if (!this.props.rowData.user) {
      return {profile_url: "/", full_name: "" }
    }
    var full_name = this.props.rowData.user.full_name
    if (full_name) {
      full_name = full_name.capitalizeFirstLetter();
    }
    return {profile_url: "/users/"+this.props.rowData.user.user_id,
            full_name: full_name
    }
  },
  
  render: function(){
    return (
      <a href={this.state.profile_url} className="btn btn-default" role="button">
        {this.state.full_name}
      </a>
      );
    
  }
});

var EditShiftComponent = React.createClass({
  displayName: 'EditShiftComponent',
  getInitialState: function(){
    if (!this.props.rowData.user) {
      return {profile_url: "/", full_name: "" }
    }
    var full_name = this.props.rowData.user.full_name
    if (full_name) {
      full_name = full_name.capitalizeFirstLetter();
    }
    return {profile_url: "/users/"+this.props.rowData.user.user_id,
            full_name: full_name
    }
  },
  
  render: function(){
    return (
      <a href={this.state.profile_url} className="btn btn-default" role="button">
        {this.state.full_name}
      </a>
      );
  }
});
  

var columnMeta = [
  {
  "columnName": "category",
  "displayName": "Category",
  "order": 1,
  "locked": false,
  "visible": true,
  },
  {
  "columnName": "name",
  "displayName": "Name",
  "order": 2,
  "locked": false,
  "visible": true,
  },
  {
  "columnName": "user",
  "displayName": "User",
  "order": 4,
  "customComponent": UserComponent
  },
  {
  "columnName": "time",
  "displayName": "Time",
  "order" :3
  },
  //{
  //"columnName": "end_time",
  //"displayName": "End Time",
  //"order" :3
  //},
  {
  "columnName": "description",
  "displayName": "Description",
  "order" :5,
  "customComponent": DescriptionComponent
  },
  {
  "columnName": "options",
  "displayName": "Options",
  "order" :5,
  "customComponent": EditShiftComponent
  },
];

var columns = [
  'category', 'name', 'user', 'time', 'description' 
  ];


var WorkShiftTable = React.createClass({
  propTypes: {
    title: React.PropTypes.string,
    //shifts: React.PropTypes.array
  },
  
  getInitialState: function() {
  return {shiftData: [
    {
    "category": "Kitchen",
    "name": "Pans",
    "user": {"full_name":"Mayers Leonard",
                "user_id" : 1},
    "time": "2:00PM - 3:00PM",
    "description": "Pans description"
  },
  ]}
  },
  
  componentDidMount: function(){
    var shifts = this.props.shifts
    console.log(shifts)
    var data = []
    for (var i = 0; i < shifts.length; i++){
      var shift = shifts[i]
      if (shift.user) {
        var user_hash = {"full_name":shift.user.first_name +" " +shift.user.last_name,
                 "user_id" : shift.user_id}  
      } else {
        var user_hash = {"full_name":"(None)",
                 "user_id" : null}
      }
      data.push({"category": shift.metashift.category,
        "user": user_hash,
        "name": shift.metashift.name,
        "time": moment(shift.start_time).format('dddd, h:mm a') + " - " +
          moment(shift.end_time).format('h:mm a'), 
        "description": shift.metashift.description,
      })
    }
    console.log(data)
    if (shifts.length > 0) {
      this.setState({shiftData: data})
    } else {
    }
  },

  render: function() {
    return (
      <div>
        <Griddle results={this.state.shiftData}
        columnMetadata={columnMeta}
        columns={columns}
        showFilter={true}/>
      </div>
    );
  }
});


module.exports = WorkShiftTable

