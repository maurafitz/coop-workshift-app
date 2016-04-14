
'use strict'

var React = require('react');
var Griddle = require('griddle-react');
var ReactDOM = require('react-dom');

var Button = require('react-bootstrap/lib/Button');
var Popover = require('react-bootstrap/lib/Popover');
var OverlayTrigger = require('react-bootstrap/lib/OverlayTrigger');
var Input = require('react-bootstrap/lib/Input');

var moment = require('moment');

var DescriptionComponent;
var USER_FIELD = "user_field";
var TIME_FIELD = "time_field";

String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
};

var allUsers = 0;

var getFullName = function(user) {
  var full_name = user.first_name + " " + user.last_name;
  return full_name.capitalizeFirstLetter();
}

var getUpdatedShifts = function(shifts, shift_id, field, new_val) {
  var new_shift;
  for (var i = 0; i < shifts.length; i++){
    if (shifts[i].shift_id == shift_id){
      if (field == USER_FIELD){
        shifts[i].user = getUserWithID(new_val);
        new_shift = shifts[i];
      } else{
        
      }
    }
  }
  return {newShifts: shifts, newShift: new_shift}
}

var getUserWithID = function(user_id){
  for (var i = 0; i < allUsers.length; i++){
    if (allUsers[i].id == user_id){
      return allUsers[i];
    }
  }
  console.log("Couldn't find user with id: " + user_id);
}

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
    console.log(this.props.rowData);
    if (!this.props.rowData.user) {
      return {profile_url: "/", full_name: "" }
    }
    var full_name = this.props.rowData.user.full_name
    return {profile_url: "/users/"+this.props.rowData.user.user_id,
            full_name: full_name, editModeOn: this.props.rowData.editModeOn
    }
  },
  
  getUserOptions: function(){
    var lst = [];
    if (this.props.rowData.user){
      lst.push(<option key={this.props.rowData.user.id} 
      value ={this.props.rowData.user.id}>{this.props.rowData.user.full_name}</option>);
    }
    for (var i = 0; i < allUsers.length; i++){
      if (!this.props.rowData.user || this.props.rowData.user.user_id != allUsers[i].id){
        //Only append to list if we haven't appended this name yet
        lst.push(<option key={allUsers[i].id} value={allUsers[i].id}>{allUsers[i].full_name}</option>);
      }
    }
    return lst
  },
  
  getUserDropdown: function(){
    return (
        <Input type="select" label="" placeholder="select" 
        ref="userOptions" onChange={this.onUserChange}>
          {this.getUserOptions()}
        </Input>
        )
  },
  
  onUserChange: function(){
    var id = this.refs.userOptions.getInputDOMNode().value;
    this.props.rowData.dataChangeCallback(USER_FIELD, this.props.rowData.shift_id, id);
  },
  
  render: function(){
    if (this.state.editModeOn) {
      return this.getUserDropdown();
    } else {
      return (
      <a href={this.state.profile_url} className="btn btn-default" role="button">
        {this.state.full_name}
      </a>
      );
    }
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
  //{
  //"columnName": "end_time",
  //"displayName": "End Time",
  //"order" :3
  //},
  {
  "columnName": "user",
  "displayName": "User",
  "order": 4,
  "customComponent": UserComponent,
  "extraProp": "this is a custom prop"
  },
  {
  "columnName": "time",
  "displayName": "Time",
  "order" :3
  },
  {
  "columnName": "description",
  "displayName": "Description",
  "order" :5,
  "customComponent": DescriptionComponent
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
  return { dirtyShifts: [],
    editMode: false,
  shiftData: [
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
    var data = []
    for (var i = 0; i < shifts.length; i++){
      var shift = shifts[i]
      if (shift.user) {
        var user_hash = {"full_name":getFullName(shift.user),
                 "user_id" : shift.user_id}  
      } else {
        var user_hash = {"full_name":"(None)",
                 "user_id" : null}
      }
      console.log(shift.start_time);
      data.push({"category": shift.metashift.category,
        "user": user_hash,
        "name": shift.metashift.name,
        "time": moment(shift.start_time).format('dddd, h:mm a') + " - " +
          moment(shift.end_time).format('h:mm a'), 
        "description": shift.metashift.description,
        "shift_id": shift.id
      })
    }
    console.log(data)
    if (shifts.length > 0) {
      this.setState({shiftData: data})
    } else {
    }
    allUsers = this.props.allusers;
    for (i = 0; i < allUsers.length; i++){
      allUsers[i].full_name = getFullName(allUsers[i]);
    }
  },
  
  getDataWEditModeAppended: function(dat, mode_on){
    for (var i= 0; i < dat.length; i ++){
      dat[i].editModeOn = mode_on;
      dat[i].dataChangeCallback = this.changeOfData;
    }
    return dat
  },
  
  changeOfData: function(field_name, shift_id, new_val){
    var shiftbundle = getUpdatedShifts(this.state.shiftData, shift_id, field_name, new_val);
    this.setState({shiftData: shiftbundle.newShifts, 
    dirtyShifts: this.state.dirtyShifts.concat([shiftbundle.newShift])});
  },
  
  sendDirtyShiftsToDB: function(){
    //Ajax call here
  },

  toggleEditMode: function() {
    this.setState({editMode: !this.state.editMode, 
    shiftData: this.getDataWEditModeAppended(this.state.shiftData, !this.state.editMode)});
  },
  render: function() {
    console.log("Dirty Shifts"); console.log(this.state.dirtyShifts);
    var saveButton;
    var editButton;
    var exitEditButton;
    if (this.props.admin){
      if (this.state.editMode) {
        saveButton =<Button color="blue" type="button">Save Workshifts</Button>
        exitEditButton = <Button color="blue" type="button"
        onClick={this.toggleEditMode}>Exit Edit Mode</Button>
      } else {
        editButton = <Button color="blue" type="button"
         onClick={this.toggleEditMode}>Edit Workshifts</Button>
      }
    }
    return (
      <div>
        <Griddle results={this.state.shiftData}
        columnMetadata={columnMeta}
        columns={columns}
        showFilter={true}
        editMode={"random string"}/>
        <br></br>
        {saveButton}
        {exitEditButton}
        {editButton}
      </div>
    );
  }
});


module.exports = WorkShiftTable

