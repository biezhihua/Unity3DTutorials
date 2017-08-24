using UnityEngine;
using System.Collections;

public class CoordinateWorld : MonoBehaviour
{
    // Use this for initialization
    private Vector3 objVector3;

    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        objVector3 = transform.InverseTransformDirection(Vector3.forward);
        transform.Translate(objVector3 * Time.deltaTime);
    }
}