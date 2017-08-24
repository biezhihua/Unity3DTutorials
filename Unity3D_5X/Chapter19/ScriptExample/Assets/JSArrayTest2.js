#pragma strict

function Start () {

	var arr = new Array ();//声明一个Array数组
	arr.Push ("hello");//添加一个元素到数组
	Debug.Log (arr[0]);
	arr.length = 2; // 调整数组大小
	arr[1] = "Unity";//赋值给第二个元素
	for (var str : String in arr)
	{
	  Debug.Log(str); // 遍历数组并打印
	}

}

function Update () {

}