using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GrayTest : MonoBehaviour
{
    public ComputeShader computeShader;
    public Texture2D texture2D;
    public RawImage image;
    // Start is called before the first frame update
    void Start()
    {
        var kernel = computeShader.FindKernel("CSMain");
        var rt = new RenderTexture(texture2D.width, texture2D.height,24);
        rt.enableRandomWrite = true;
        rt.Create();
        
        computeShader.SetTexture(kernel, "inputTex", texture2D);
        computeShader.SetTexture(kernel, "outputTex", rt);
        computeShader.Dispatch(kernel, 100, 100, 1);

        image.texture = rt;

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
