
// To Update the branchid in both customer table and order_bookingtbl
//select branchid,branch_name from vff.branchtbl where city='Belgaum'
//update vff.laundry_customertbl set branchid='' where consmrid=''

//1.New Booking Insert Query
// insert into vff.laundry_order_bookingtbl(customerid,address,city,pincode,landmark,clat,clng,booking_status,branch_id) values () returning bookingid

//2.Send Notification to Delivery boy who is Free to take Orders
//select usrname,delivery_boy_id,branchid,device_token from vff.usertbl,vff.laundry_delivery_boytbl where laundry_delivery_boytbl.usrid=usertbl.usrid and laundry_delivery_boytbl.status='Free' and laundry_delivery_boytbl.is_online='1' and branch_id='';

//3.Add into Notification Table while sending notification to delivery Boy
//insert into vff.laundry_notificationtbl(title,body,intent,reciever_id,sender_id,booking_id,branch_id) values ('"+str(title)+"','"+str(body)+"','"+str(intent)+"','"+str(delivery_boy_id_str)+"','"+str(senderid)+"','"+str(orderid)+"')

//3.Load Notification Accept to Delivery Boy where delivery_boy_id is '-1' //Using booking_id sent in notification //Delivery_boy branch_id
//select bookingid,customerid,address,city,pincode,landmark,clat,clng,time_at,customer_name from vff.laundry_order_bookingtbl,vff.laundry_customertbl where laundry_order_bookingtbl.customerid=laundry_customertbl.consmrid and bookingid='1' and delivery_boy_id='-1' and bookingid='"+str(booking_id)+" and branch_id='"+str(branch_id)+"''

//4.Saving to order_accept_tbl //If Rejected save that also there only but remember to send notification to admin panel
//insert into vff.laundry_delivery_accept_tbl(delivery_boy_id,status,booking_id,branch_id) values ()

//5.IF Order is Accepted by Delivery Boy then Save it into Order_assigned Table and Update into Booking Table
//insert into vff.laundry_order_assignmenttbl(booking_id,delivery_boy_id,type_of_order) values ()

//6.Load Orders Booking for Customer //Loading even if order_status is not Accepted
//select bookingid,delivery_boy_id,booking_status,time_at from vff.laundry_order_bookingtbl where customerid='' and branch_id=''

//7.Order /Booking Details for order details screen
//select customerid,laundry_order_bookingtbl.delivery_boy_id,address,city,pincode,landmark,clat,clng,booking_status,time_at from vff.laundry_delivery_boytbl,vff.laundry_order_bookingtbl where laundry_order_bookingtbl.delivery_boy_id=laundry_delivery_boytbl.delivery_boy_id and laundry_order_bookingtbl.delivery_boy_id!='-1' and laundry_order_bookingtbl.branch_id='1' and bookingid='3' and customerid='4'

//8.Add Items To Cart againt booking_id
//insert into vff.laundry_cart_items(catid,subcatid,customer_id,booking_id,booking_type,cat_img,cat_name,sub_cat_name,sub_cat_img,actual_cost,time,item_cost,item_quantity,type,section_type) 

//9.Add Extra Items to Cart againt booking_id
//insert into vff.laundry_cart_extra_items_tbl(extra_item_id,price,extra_item_name,booking_id)

//10.Place Order
//insert into vff.laundry_ordertbl(customerid,delivery_boyid,quantity,price,clat,clng,order_status,additional_instruction,booking_id) values () returning orderid
//To Load all cart Items into Active Order table
//insert into vff.laundry_active_orders_tbl(booking_id,categoryid,subcategoryid,booking_type,cat_img,cat_name,sub_cat_name,sub_cat_img,actual_cost,item_cost,item_quantity,type,section_type) select booking_id,catid,subcatid,booking_type,cat_img,cat_name,sub_cat_name,sub_cat_img,actual_cost,item_cost,item_quantity,type,section_type from vff.laundry_cart_items  where customer_id='' and booking_id=''
//Cart Extra Items Like Softner,etc
//insert into vff.laundry_cart_extra_items_tbl(extra_item_id,price,extra_item_name,order_id) values ('"+str(extra_id)+"','"+str(extra_item_price)+"','"+str(extra_name)+"','"+str(order_id)+"')"

//11.Payment after Order ID is Generated
//insert into vff.laundry_payment_tbl (order_id,razor_pay_payment_id,status,branch_id,payment_type) values ()

//12.Load Order details Home Screen if Order ID is generated
//select orderid,epoch,pickup_dt,clat,clng,customer_name,laundry_customertbl.usrid,delivery_boyid,name as delivery_boy_name,order_status from vff.laundry_delivery_boytbl,vff.laundry_customertbl,vff.laundry_ordertbl where laundry_customertbl.consmrid=laundry_ordertbl.customerid and laundry_delivery_boytbl.delivery_boy_id=laundry_ordertbl.delivery_boyid  and laundry_ordertbl.customerid='"+str(customer_id)+"' and order_completed='0' order by orderid desc

//13.Load Detailed Order details
//select laundry_ordertbl.epoch,pickup_dt,clat,clng,delivery_boyid,name as delivery_boy_name,order_status,delivery as delivery_date,houseno,address,landmark,pincode,delivery_epoch,cancel_reason,feedback,laundry_ordertbl.customerid from vff.usertbl,vff.laundry_delivery_boytbl,vff.laundry_customertbl,vff.laundry_ordertbl where laundry_customertbl.consmrid=laundry_ordertbl.customerid and usertbl.usrid=laundry_customertbl.usrid and laundry_delivery_boytbl.delivery_boy_id=laundry_ordertbl.delivery_boyid  and order_completed='"+str(order_status)+"' and orderid='"+str(order_id)+"' order by orderid desc
//Selected Items Details
//select cat_name,cat_img,sub_cat_name,sub_cat_img,categoryid,subcategoryid,ordertype,dt,time,item_cost,item_quantity,type,section_type from vff.laundry_active_orders_tbl where order_id='"+str(order_id)+"'

//Current Order for delivery boy
//select laundry_order_assignmenttbl.delivery_boy_id,type_of_order,order_id,bookingid,customerid,address,city,pincode,landmark,clat,clng,time_at,booking_status from vff.laundry_order_assignmenttbl,vff.laundry_order_bookingtbl where laundry_order_assignmenttbl.booking_id=laundry_order_bookingtbl.bookingid and laundry_order_assignmenttbl.delivery_boy_id='4' and type_of_order='Drop' order by timing desc limit 1

//Current Order with Order ID
//select laundry_order_assignmenttbl.delivery_boy_id,type_of_order,orderid,laundry_order_bookingtbl.bookingid from vff.laundry_order_assignmenttbl,vff.laundry_order_bookingtbl,vff.laundry_ordertbl where laundry_ordertbl.orderid=laundry_order_assignmenttbl.order_id and laundry_ordertbl.booking_id=laundry_order_bookingtbl.bookingid and laundry_order_assignmenttbl.booking_id=laundry_order_bookingtbl.bookingid and laundry_order_assignmenttbl.delivery_boy_id='4' order by timing desc limit 1;
