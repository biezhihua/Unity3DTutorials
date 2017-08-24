#pragma strict

function Start () {

	var sumFunc:Function=Sum;
	print(Sum(1,2));
	print(sumFunc(3,4));

}

function Sum(num1:int,num2:int):int
{
	return num1+num2;
}
