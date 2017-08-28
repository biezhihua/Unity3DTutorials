using UnityEngine;
using System.Collections;

public class ObjTrans3 : MonoBehaviour
{
    // Use this for initialization
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        var speed = 30.0f;
        Mathf
        transform.RotateAround(Vector3.zero, Vector3.up, speed * Time.deltaTime);
    }
}