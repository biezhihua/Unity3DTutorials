#pragma strict

function Start () {
	var i:int=0;
	var x:int=0;
	var y:int=0;
	
	while(i<10)
	 {
		Debug.Log(i);
		i++; 
	}
	
	for(;x<10;++x)
	{
		Debug.Log(x);
	}
	
	do
	{
	   Debug.Log(y);
	   ++y;
	}while(y<10);

}

function Update () {

}