// var formatDisplayTime= function(shift){
//     if (this.props.table_type == W_SHIFT_TABLE){
//       return shift.day + " " + shift.start_time + " - " + shift.end_time
//     } else{
//       return moment(shift.date).format('dddd, h:mm a') 
//     }
//   };
  
var CONST = require('./constants');
var moment = require('moment');

var weekdays = moment.weekdays()

exports.getCategory = function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
        return shift.metashift.category
    } else{
        return shift.workshift.metashift.category
    }
}

exports.getMetashift = function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
        return shift.metashift
    } else{
        return shift.workshift.metashift
    }
}

exports.formatDisplayTime= function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
      return shift.day + " " + shift.start_time + " - " + shift.end_time
    } else{
      return moment(shift.date).format('MMM Do, h:mm a') 
    }
  }

exports.getPutURI= function(first_id, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
      return '/workshifts/' + first_id + '/change_users';
    } 
    return '/shifts/' + first_id + '/change_users';
  }

exports.sortableTime = function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
        return getDayNum(shift.day) * 24 + getStartNum(shift.start_time);
    } else {
        return moment(shift.date).format('X');
    }
}

var getDayNum = function(str){
    for (var i = 0; i < weekdays.length; i++){
        if (str === weekdays[i]){
            return i
        }
    }
    return 6
}

var getStartNum = function(start_time){
    var a = 0
    if (start_time.indexOf('p') > -1){
        a = 12
    }
    return a + parseInt(start_time.match(/\d+/))
}