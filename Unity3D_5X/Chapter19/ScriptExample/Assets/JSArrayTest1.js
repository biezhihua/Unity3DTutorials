#pragma strict
var ArrayTest1 : int[]=[1,2,3,4,5];
function Start () {
	for (var i:int in ArrayTest1) {
	Debug.Log(i);//遍历数组并打印
	}
}

function Update () {

}