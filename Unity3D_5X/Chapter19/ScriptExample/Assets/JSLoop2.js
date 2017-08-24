#pragma strict

function Start () {

	var nameArray:String[]=["Jack","Tom","Rose"];
	for(var  str:String  in  nameArray)
	{
	   Debug.Log(str);//遍历数组并打印
	}

}

function Update () {

}