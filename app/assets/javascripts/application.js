// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-1.8.2
//= require_tree .


function approve_selected_users(action) {
    $("#success_msg").text("");
    var user_ids = [];
    $("td input#brandslip_user").each(function() {
        if ($(this).is(':checked')) {
            user_ids.push($(this).attr('value'));
        }
    });
    var is_approved = 0;
    if(action == "approve"){
        is_approved = 1;
    }else if(action == 'reject'){
        is_approved = 2;
    }
    if (user_ids.length > 0) {
        $.ajax({
            url: "action_on_selected_user",
            type: "post",
            dataType: 'json',
            data: {
                "user_id": user_ids,
                "is_approved": is_approved
            },
            beforeSend: function() {
                $("#ajaxloading").css({
                    'display': 'inline-block'
                });
            },
            complete: function() {
                $("#ajaxloading").css({
                    'display': 'none'
                });
            },
            success: function(data) {
                
                for(var index = 0; index < user_ids.length; index ++){
                    var status = "";
                    if(action == 'approve'){
                        status = "Approved";
                        $("#tr_"+user_ids[index]).find("td#td_status").text(status).css("color", "green");
                    }else if(action == 'reject'){
                        status = "Rejected";
                        $("#tr_"+user_ids[index]).find("td#td_status").text(status).css("color", "red");
                    }
                }
                if(action=='approve'){
                    $("span#success_msg").text("User(s) approved Successfully ").css("color", "green");
                }else{
                    $("span#success_msg").text("User(s) rejected Successfully ").css("color", "red");
                }
                
            }
        });  
    } else {
        alert('Please select atleast one user to ' + action);
    }
    return false;
}


function send_message(){
    var from_user_id = $("#from_user").val();
    var to_user_id = $("#to_user").val();
    var first_name = $("#first_name").val();
    var last_name = $("#last_name").val();
    var company_name = $("#company_name").val();
    var message_title = $("#message_title").val();
    var message_body = $("#message_body").val();
    if(to_user_id == ""){
        alert("Please select user to send message.");
    }else{
        $.ajax({
            url: "send_message",
            type: "post",
            dataType: 'json',
            data: {
                "from_user_id": from_user_id,
                "to_user_id": to_user_id,
                "message_title": message_title,
                "message_body": message_body,
                "first_name": first_name,
                "last_name": last_name,
                "company_name": company_name
            },
            beforeSend: function() {
                $("#ajaxloading").css({
                    'display': 'inline-block'
                });
            },
            complete: function() {
                $("#ajaxloading").css({
                    'display': 'none'
                });
            },
            success: function() {
                $("#success_msg").text("Message sent Successfully").css('color', 'green');
                $("#to_user").val("");
                $("input#message_title").val("");
                $("#message_body").val("");
            }
        });        
    }
             
}

function delete_selected_messages(msg_id, ctrl){
   var answer = confirm("Are you sure you want to delete this Message?");
        if (answer) {
            $.ajax({
                url: "delete_messages",
                type: "post",
                dataType: 'json',
                data: {
                    "delete_message_id": msg_id
                },
                beforeSend: function() {

                },
                complete: function() {

                },
                success: function() {
                    $(ctrl).closest("div#msg_div").remove();
                }
            }); 
        }        
}

function reply_to_message(ctrl){
    var msg_from_user = $(ctrl).closest("div#msg_div").find("span#msg_from_user").text();
    var msg_subject = "Re: " + $(ctrl).closest("div#msg_div").find("span#msg_subject").text();
    var user_interest = $(ctrl).attr("data-user-interest-id");
    var user_id = $(ctrl).attr("data-user-id");
    $("#myModal").find("input#message_title").val(msg_subject);
    $("#myModal").find("#msg_user_interest").val(user_interest);
    $("#myModal").find("#to_user option").remove();
    var option_html = "<option value="+user_id+">"+msg_from_user+"</option>"
    $("#myModal").find("#to_user").html(option_html);
    
}

function reset_msg_box(){
    // $(".modal-dialog").find("#msg_user_interest").val('');
    // $(".modal-dialog").find("#to_user option").remove();
    // $(".modal-dialog").find("#to_user").html("<option value=''>Select User</option>");
    $(".modal-dialog").find("#message_title").val('');
    $(".modal-dialog").find("#message_body").val('');
}


$("input#user_group_id").live('click', function(){
   var category_arr = [];
   var crowd_size_arr = [];
   $("ul#category_filter input#user_group_id").each(function(){
       if($(this).is(':checked')){
           category_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#crowd_size_filter input#user_group_id").each(function(){
       if($(this).is(':checked')){
           crowd_size_arr.push($(this).closest('li').find('a').text());
       }
   });
   if(category_arr.length == 0){
       category_arr.push(-1);
   }
   if(crowd_size_arr.length == 0){
       crowd_size_arr.push(-1);
   }
   
    $.ajax({
        url: "search_job_filter",
        type: "post",
        data: {
            "category_arr": category_arr,
            "crowd_size_arr": crowd_size_arr,
            "job_user_id": $("input#job_user_id").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_jobs").html(data);
            $("span#result_found").text($("div#searched_job_div").length);
        }
    });     
});

$("input#chk_valid_for").live('click', function(){
    $.ajax({
        url: "search_job_filter_by_valid_for",
        type: "post",
        data: {
            "valid_for": $(this).attr('data-val'),
            "job_user_id": $("input#job_user_id").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_jobs").html(data);
            $("span#result_found").text($("div#searched_job_div").length);
        }
    });     
});


function search_by_location(){
    var state = $("#job_state").val();
    var city = $("#job_city").val();
    if(state == ""){
        alert("Please select state.");
        return false;
    }
    if(city == ""){
        alert("Please select city.");
        return false;
    }
    $.ajax({
        url: "search_job_filter_by_location",
        type: "post",
        data: {
            "state": state,
            "city": city,
            "job_user_id": $("input#job_user_id").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_jobs").html(data);
            $("span#result_found").text($("div#searched_job_div").length);
        }
    });  
}


$("input#user_presenter_interest_id").live('click', function(){
   var category_arr = [];
   $("input#user_presenter_interest_id").each(function(){
       if($(this).is(':checked')){
           category_arr.push($(this).attr('data-val'));
       }
   });
   if(category_arr.length == 0){
       category_arr.push(-1);
   }
    $.ajax({
        url: "search_profile_filter",
        type: "post",
        data: {
            "category_arr": category_arr
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#presenter_profile").html(data);
        }
    });     
});


$("input#user_brand_interest_id").live('click', function(){
   var category_arr = [];
   $("input#user_brand_interest_id").each(function(){
       if($(this).is(':checked')){
           category_arr.push($(this).attr('data-val'));
       }
   });
   if(category_arr.length == 0){
       category_arr.push(-1);
   }
    $.ajax({
        url: "search_brand_filter",
        type: "post",
        data: {
            "category_arr": category_arr
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#brand_profile").html(data);
        }
    });     
});

$(".chk_all_category").live('click', function(){
    if($(this).is(':checked')){
        $("ul#category_filter").find("input[type='checkbox']").not('.chk_all_category').each(function(){
            console.log($(this));
            $(this).attr('checked', false);
            $(this).attr('disabled', 'disabled');
        });
    }else{
        $("ul#category_filter").find("input[type='checkbox']").not('.chk_all_category').each(function(){
            $(this).removeAttr('disabled');
        });        
    }
});

$(".chk_all_crowd_size").live('click', function(){
    if($(this).is(':checked')){
        $("ul#crowd_size_filter").find("input.chk_crowd_size").each(function(){
            $(this).attr('checked', false);
            $(this).attr('disabled', 'disabled');
        });
    }else{
        $("ul#crowd_size_filter").find("input.chk_crowd_size").each(function(){
            $(this).removeAttr('disabled');
        });        
    }
});

function delete_job_proposal(proposal_id,ctrl){
    if(proposal_id == ""){
        alert("Proposal not found");
    }else{
        var answer = confirm("Are you sure you want to delete this bid?");
        if (answer) {
            var btn = $(ctrl);
            $.ajax({
                url: "delete_job_proposal",
                type: "post",
                dataType: "json",
                data: {
                    "proposal_id": proposal_id
                },
                beforeSend: function() {
                },
                complete: function() {
                },
                success: function(data) {
                    btn.closest('div#post_bid_div').remove();
                }
            });   
        }
    }
}

function add_newsfeed(){
    if($("#newsfeed_description").val() == ""){
        alert("Please enter newsfeed description.");
    }else{
            $.ajax({
                url: "add_newsfeed",
                type: "post",
                dataType: "json",
                data: {
                    "newsfeed_desc": $("#newsfeed_description").val()
                },
                beforeSend: function() {
                    $("#newsfeed_add_ajaxloading").css("display", "inline-block");
                },
                complete: function() {
                    $("#newsfeed_add_ajaxloading").css("display", "none");
                },
                success: function(data) {
                    $("#newsfeed_add_success_msg").text("Newsfeed added successfully.");
                }
            });           
    }
}