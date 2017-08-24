#pragma strict

function Start ()
{
	Debug.Log ("Starting " + Time.time);
	yield WaitAndPrint(); //启动协同程序WaitAndPrint
	print ("Done " + Time.time);
}
function WaitAndPrint () {
    yield WaitForSeconds (5);//等待5秒
    print ("WaitAndPrint "+ Time.time);//打印当前时间
}
