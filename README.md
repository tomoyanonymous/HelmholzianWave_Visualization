# Visualization of Helmholzian Wave Propagation with Processing

## Sample Image

![](./B2.png)

![](./B5.png)

## Usage

Global setting of diagram is "diagram.init(pos,n1,n2)" in void setup().

arguments:

- pos: bowing position in a range of 0~1. 0 is left end of the string and vice virsa.
- n1 : number of clockwise-helmholzian wave.
- n2 : number of counterclockwise-helmholzian wave.

```java
// in void setup()
diagram.init(3./8,7,2);
```

_caution: combination of arguments is need to be proper. It has no varidation function, see the reference paper below._

## Reference

久保田秀美「弓で擦った弦の定常振動の運動学的研究」日本音響学会誌43巻5号（1987）

Kubota Hidemi "Kinematical study of the bowed string." The Journal of the Acoustical Society of Japan 43-5(1987)

## Author

by Matsuura Tomoya

<https://matsuuratomoya.com>

## License

MIT License
