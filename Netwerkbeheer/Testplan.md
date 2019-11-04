# Test plan

## Prep

1. Steek 1 pc1 in switch 7 en geef ip: 172.18.1.70 255.255.255.224 en default gateway: 172.18.1.65
1. Steek 1 pc2 in switch 5 en geef ip: 172.18.1.8  255.255.255.192 en default gateway: 172.18.1.7
1. Steek 1 pc3 in switch 4 en geef ip: 172.18.1.20 255.255.255.0   en default gateway: 172.18.0.1

## Test steps

### Connectiviteit

1. Ping van pc1 naar pc2
2. Ping van pc1 naar pc3
3. Ping van pc2 naar pc3

### Internet

1. Test internet connectiviteit op pc1
2. Test internet connectiviteit op pc2
3. Test internet connectiviteit op pc3
