// var formatDisplayTime= function(shift){
//     if (this.props.table_type == W_SHIFT_TABLE){
//       return shift.day + " " + shift.start_time + " - " + shift.end_time
//     } else{
//       return moment(shift.date).format('dddd, h:mm a') 
//     }
//   };
  
var CONST = require('./constants')

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