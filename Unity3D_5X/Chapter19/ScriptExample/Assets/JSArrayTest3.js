#pragma strict

function Start () {
	var array = new Array (1, 2,3); //定义Array数组
	var builtinArray : int[] = array.ToBuiltin(int);// Array数组赋值给内建数组
	var newarr = new Array (builtinArray);// 将内建数组赋值给Array数组
	Debug.Log(array);
	Debug.Log (newarr);
}

function Update () {

}