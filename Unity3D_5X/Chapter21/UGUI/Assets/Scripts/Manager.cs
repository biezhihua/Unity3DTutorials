using UnityEngine;
using System.Collections;

public class Manager : MonoBehaviour {
    private Typer typer;
    private Animator menuAnim;
    private bool menuOn;

    void Awake()
    {
        typer = GetComponentInChildren<Typer>();
        menuAnim = GetComponent<Animator>();
    }

    public void BeginMenu()
    {
        if (!menuOn)
        {
            menuAnim.SetTrigger("FadeIn");
            typer.StartCoroutine("TypeIn");
            menuOn = true;
        }
        else
        {
            menuAnim.SetTrigger("FadeOut");
            typer.StartCoroutine("TypeOff");
            menuOn = false;
        }
    }

}
