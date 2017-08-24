using UnityEngine;
using System.Collections;

public class CSharpArray : MonoBehaviour {

	public int[] array=new int[5];

	// Use this for initialization
	void Start () {

		for(int i=0;i<array.Length;i++)
		{
			array[i]=i;
		}
		foreach(int item in array ) Debug.Log(item);

	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
