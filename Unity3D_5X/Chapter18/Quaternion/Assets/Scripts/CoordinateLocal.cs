using System.Collections;
using UnityEngine;

public class CoordinateLocal : MonoBehaviour {

    // Use this for initialization
    void Start () {

    }

    // Update is called once per frame
    void Update () {

        //让物体沿着Z轴方向向前移动，Time.deltaTime表示Update()方法上一帧持续时间
        transform.Translate (Vector3.forward * Time.deltaTime);
    }
}