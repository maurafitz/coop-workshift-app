
'use strict'

var React = require('react');
var Griddle = require('griddle-react');
var ReactDOM = require('react-dom');
var Util = require('./table_utils.js');

var Button = require('react-bootstrap/lib/Button');
var Popover = require('react-bootstrap/lib/Popover');
var OverlayTrigger = require('react-bootstrap/lib/OverlayTrigger');
var Input = require('react-bootstrap/lib/Input');
var noty = require('noty');

var moment = require('moment');

var DescriptionComponent;
var USER_FIELD = "user_field";
var TIME_FIELD = "time_field";
var CONST = require('./constants')

var allUsers = 0;

var getUpdatedShifts = function(shifts, shift_id, field, new_val) {
  var new_shift;
  for (var i = 0; i < shifts.length; i++){
    if (shifts[i].shift_id == shift_id){
      if (field == USER_FIELD){
        shifts[i].user = getUserWithID(new_val);
        new_shift = shifts[i];
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

var TimeComponent = React.createClass({
  displayName: 'DescriptionComponent',
  render: function(){
    return (
      <div>
        {this.props.rowData.formattedTime}
      </div>
    );}
});

DescriptionComponent = React.createClass({
  displayName: 'DescriptionComponent',
  render: function(){
    return (
      <div>
        <OverlayTrigger trigger="focus" placement="left" 
            overlay={<Popover title={this.props.rowData.shift} 
            id={this.props.rowData.shift_id + "he"}>{this.props.rowData.description}</Popover>}>
          <Button color="blue" type="button">Description</Button>
        </OverlayTrigger>
      </div>
    );}
});

var SignoffComponent = React.createClass({
  displayName: 'SignoffComponent',
  getInitialState: function(){
    var dat = this.props.rowData.signoff_status
    var overdue = false
    var user = ""
    if (dat.signed_off){
      user = dat.user
    }
    return {showPopup: dat.signed_off, user: user}
  },
  
  getPopover: function(){
    return (
      <div> </div>
      )
  },
  
  render: function(){
    
    return (
      <div>
        <OverlayTrigger trigger="focus" placement="left" 
            overlay={<Popover title={'Signed off?'} 
            id={this.props.rowData.shift_id + "sign-comp"}>{this.state.showPopup}</Popover>}>
          <Button color="blue" type="button">{this.state.showPopup}</Button>
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
    return {profile_url: "/users/"+this.props.rowData.user.id,
            full_name: full_name, editModeOn: this.props.rowData.editModeOn
    }
  },
  
  getUserOptions: function(){
    var lst = [];
    var u_id = -1;
    if (this.props.rowData.user){
      u_id = this.props.rowData.user.id
      lst.push(<option key={this.props.rowData.user.id+ "-" + this.props.rowData.shift_id} 
      value ={this.props.rowData.user.id}>{this.props.rowData.user.full_name}</option>);
    }
    for (var i = 0; i < allUsers.length; i++){
      if (!this.props.rowData.user || u_id != allUsers[i].id){
        //Only append to list if we haven't appended this name yet
        lst.push(<option key={allUsers[i].id + "-" + this.props.rowData.shift_id} 
        value={allUsers[i].id}>{allUsers[i].full_name}</option>);
      }
    }
    return lst
  },
  
  getUserDropdown: function(){
    return (
        <Input  type="select" label="" placeholder="select" 
        ref="userOptions" key={this.props.rowData.shift_id} onChange={this.onUserChange}>
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
  //{
  //"columnName": "end_time",
  //"displayName": "End Time",
  //"order" :3
  //},
  {
  "columnName": "user_full_name",
  "displayName": "Member(s) Assigned",
  "order": 4,
  "customComponent": UserComponent,
  "extraProp": "this is a custom prop"
  },
  {
  "columnName": "time",
  "displayName": "Time",
  "customComponent": TimeComponent,
  "order" :3
  },
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
  {
  "columnName": "signoff_status",
  "displayName": "Sign-off Status",
  "order" :6,
  "customComponent": SignoffComponent
  },
];

var columnsNotToShow = [
  'user.full_name', 'user', 'formattedTime', 'shift_id'
  ];

var columns = [
  'category', 'name', 'user_full_name', 'time', 'description' 
  ];


var WorkShiftTable = React.createClass({
  propTypes: {
    title: React.PropTypes.string,
  },
  
  getInitialState: function() {
  return { table_type: CONST.W_SHIFT_TABLE, dirtyShifts: [],
    editMode: false,
  shiftData: [
    {
    "category": "This should never show",
    "name": "Broken",
    "user": {"full_name":"Mayers Leonard",
                "user_id" : 1},
    "time": "2:00PM - 3:00PM",
    "description": "Pans description"
  },
  ]}
  },
  
  componentDidMount: function(){
    var shifts = this.props.shifts
    // console.log(this.props);
    
    var data = this.initDataArray(shifts)
    //Only showing sign-off status on history table for now
    if (this.props.table_type == CONST.SHIFT_TABLE){
      columns.push('signoff_status')
    } else {
      columnsNotToShow.push('signoff_status')
    }
    if (shifts.length > 0) {
      this.setState({shiftData: data})
    } else {
    }
    allUsers = this.props.allusers;
    // console.log(allUsers);
    for (var i = 0; i < allUsers.length; i++){
      allUsers[i].full_name = Util.getFullName(allUsers[i]);
    }
  },
  
  initDataArray: function(shifts){
    var data = [];
    var wst = this.props.table_type == CONST.W_SHIFT_TABLE
    for (var i = 0; i < shifts.length; i++){
      var shift = shifts[i]
      if (shift.user) {
        var user_hash = {"full_name":Util.getFullName(shift.user),
                 "id" : shift.user_id}  
      } else {
        var user_hash = {"full_name":"(None)",
                 "user_id" : null}
      }
      var metashift = Util.getMetashift(shift, this.props);
      data.push({"category": metashift.category,//  shift.metashift.category,
        "user": user_hash,
        "name": metashift.name,
        "formattedTime": Util.formatDisplayTime(shift, this.props), 
        "description": metashift.description,
        "time": Util.sortableTime(shift, this.props),
        "shift_id": shift.id,
        "user_full_name": user_hash.full_name,
        "signoff_status": Util.getSignOffHash(shift, this.props).signed_off
      })
    }
    return data;
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
    var shift_ids = []; var user_ids = [];
    var shift = this.state.dirtyShifts[0]
    for (var i = 0; i < this.state.dirtyShifts.length; i++){
      shift_ids.push(this.state.dirtyShifts[i].shift_id);
      user_ids.push(this.state.dirtyShifts[i].user.id);
    }
    var postURI = Util.getPutURI(shift_ids[0], this.props);
    var that = this
    $.ajax({
      type: "PUT",
      url: postURI,
      data: JSON.stringify({user_ids: user_ids, shift_ids: shift_ids}),
      contentType: 'application/json', // format of request payload
      dataType: 'text', // format of the response
      success: function(msg) {
        noty({text: msg,
              theme: 'relax', layout: 'topRight', type: 'success',
              timeout: 1000
        });
        that.setState({dirtyShifts: []});
        that.toggleEditMode();
      },
      error: function(msg){
        noty({text: msg.status+ ": " + msg.responseText,
              theme: 'relax', layout: 'topRight', type: 'error',
              timeout: 5000
        });
      }
    });
  },

  toggleEditMode: function() {
    this.setState({editMode: !this.state.editMode, 
    shiftData: this.getDataWEditModeAppended(this.state.shiftData, !this.state.editMode)});
  },
  
  render: function() {
    var saveButton;  var editButton; var exitEditButton;
    if (this.props.admin){
      if (this.state.editMode) {
        saveButton =<Button color="blue" type="button" onClick={this.sendDirtyShiftsToDB}>Save Workshifts</Button>
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
        metadataColumns={columnsNotToShow}
        columns={columns}
        showFilter={true}
        initialSort={'time'}
        enableInfiniteScroll={true}
        bodyHeight={400}
        useFixedHeader={true}
        // resultsPerPage={100}
        showSettings={true}/>
        <br></br>
        {saveButton}
        {exitEditButton}
        {editButton}
      </div>
    );
  }
});


module.exports = WorkShiftTable

