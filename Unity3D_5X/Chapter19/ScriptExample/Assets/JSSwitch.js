#pragma strict

function Start () {
	var player:String="Jack";
	switch(player)  //如果player与某个case相匹配，那么其后的代码就会被执行。
	{
		case "Tom":
		Debug.Log ("this is Tom");
		break;         //用break来阻止代码自动地向下一个case运行。
		case "Jack":
		Debug.Log ("hi,Jack");
		break;
		case "Rose":
		Debug.Log ("Nice to meet you");
		break;
		default:       //default用于没有匹配条件时执行的代码。
		break;
	}
}

function Update () {

}